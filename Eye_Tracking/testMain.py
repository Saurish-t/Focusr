import cv2
import mediapipe as mp
import numpy as np
import matplotlib.pyplot as plt
from math import hypot
from sklearn.preprocessing import PolynomialFeatures, StandardScaler
from sklearn.linear_model import LinearRegression
from scipy.spatial.transform import Rotation as R
from eye.eye import Find_Full_Eye_Region
from eye.pupil import find_Gaze
from head.head_pose import get_head_pose
from head.gaze_line import draw_gaze_line
from flask_socketio import SocketIO, emit
from flask import Flask, request, jsonify, send_file
import os
import base64
import eventlet

eventlet.monkey_patch

app = Flask(__name__)
socketio = SocketIO(app, cors_allowed_origins="*")


mp_face_mesh = mp.solutions.face_mesh
face_mesh = mp_face_mesh.FaceMesh(static_image_mode=False, max_num_faces=1, min_detection_confidence=0.5)
points = [33, 160, 158, 133, 153, 144]
rpoints = [362, 385, 387, 263, 373, 380]

poly = PolynomialFeatures(1)
model_x = None
model_y = None
model_rx = None
model_ry = None
alpha = 0.2 
calibrated = False
times = 0
count = 0
pupil_x_coords = []
pupil_y_coords = []
r_pupil_x_coords = []
r_pupil_y_coords = []
ema_pupil_x, ema_pupil_y = None, None
predicted_x = 0
predicted_y = 0

UPLOAD_FOLDER = 'received_images'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)


def get_Blinking(eyePoints, landmarks):
    left_pointL = (landmarks[eyePoints[0]][0], landmarks[eyePoints[0]][1])
    right_pointL = (landmarks[eyePoints[3]][0], landmarks[eyePoints[3]][1])
    top_pointL = midpoint(landmarks[eyePoints[1]], landmarks[eyePoints[1]])
    bottom_pointL = midpoint(landmarks[eyePoints[4]], landmarks[eyePoints[4]])

    hLineLength = hypot((left_pointL[0] - right_pointL[0]), (left_pointL[1] - right_pointL[1]))
    vLineLength = hypot((top_pointL[0] - bottom_pointL[0]), (top_pointL[1] - bottom_pointL[1]))

    return vLineLength / hLineLength

def midpoint(place1, place2):
    return int((place1[0] + place2[0]) / 2), int((place1[1] + place2[1]) / 2)

def map_pupil_to_screen(pupil_pos, pupil_r_pos, screen_width, screen_height):
    pupil_x, pupil_y = pupil_pos
    pupil_rx, pupil_ry = pupil_r_pos

    global ema_pupil_x, ema_pupil_y, ema_pupil_rx, ema_pupil_ry

    if ema_pupil_x is None:
        ema_pupil_x, ema_pupil_y = pupil_x, pupil_y
        ema_pupil_rx, ema_pupil_ry = pupil_rx, pupil_ry
    else:
        ema_pupil_x = alpha * pupil_x + (1 - alpha) * ema_pupil_x
        ema_pupil_y = alpha * pupil_y + (1 - alpha) * ema_pupil_y
        ema_pupil_rx = alpha * pupil_rx + (1 - alpha) * ema_pupil_rx
        ema_pupil_ry = alpha * pupil_ry + (1 - alpha) * ema_pupil_ry

    pupil_x_poly = poly.transform([[ema_pupil_x]])
    pupil_y_poly = poly.transform([[ema_pupil_y]])
    pupil_rx_poly = poly.transform([[ema_pupil_rx]])
    pupil_ry_poly = poly.transform([[ema_pupil_ry]])

    stacked_pupil_poly = np.hstack((pupil_x_poly, pupil_y_poly))
    stacked_pupil_polyr = np.hstack((pupil_rx_poly, pupil_ry_poly))
    
    # screen_coords = model.predict(stacked_pupil_poly)
    # screen_coordsr = model.predict(stacked_pupil_polyr)

    pred_x = model_x.predict(poly.transform(np.array([[pupil_x]])))
    pred_y = model_y.predict(poly.transform(np.array([[pupil_y]])))
    pred_rx = model_rx.predict(poly.transform(np.array([[pupil_rx]])))
    pred_ry = model_ry.predict(poly.transform(np.array([[pupil_ry]])))

    screen_coords = (pred_x, pred_y)
    rscreen_coords = (pred_rx, pred_ry)
    
    screen_coords_avg = ((screen_coords[0] + rscreen_coords[0]) / 2, (screen_coords[1] + rscreen_coords[1]) / 2)

    print(f'Screen_coords: {screen_coords_avg}')


    predicted_x = screen_coords_avg[0][0]
    predicted_y = screen_coords_avg[1][0]
    
    return predicted_x, predicted_y

@socketio.on('connect')
def handle_connect():
    print('Client connected')

@socketio.on('disconnect')
def handle_disconnect():
    print('Client disconnected')

@socketio.on('image')
def upload_image(data):
    print("recieved")
    global calibrated, times, count, pupil_x_coords, pupil_y_coords, r_pupil_x_coords, r_pupil_y_coords
    global model_x, model_y, model_rx, model_ry

    # file = request.files['image']

    # file_bytes = file.read()
    # nparr = np.frombuffer(file_bytes, np.uint8)
    # frame = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    image_data = base64.b64decode(data['image'])
    nparr = np.frombuffer(image_data, np.uint8)
    frame = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    frame = cv2.resize(frame, (400, 850))


    filename = 'recieved_image.jpg'
    filepath = os.path.join(UPLOAD_FOLDER, filename)
    cv2.imwrite(filepath, frame)

    frame_height, frame_width = frame.shape[:2]
    rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    results = face_mesh.process(rgb_frame)

    if results.multi_face_landmarks:
        for face_landmarks in results.multi_face_landmarks:
            landmarks = [(int(lm.x * frame_width), int(lm.y * frame_height)) for lm in face_landmarks.landmark]

            gaze_ratioL, eye_origin, pupil_center, test_values = find_Gaze(points, landmarks, 65, 1, frame)
            gaze_ratioR, eye_originR, pupil_centerR, test_valuesR = find_Gaze(rpoints, landmarks, 65, 1, frame)

            normalized_pupil_x, normalized_pupil_y = test_values
            rnormalized_pupil_x, rnormalized_pupil_y = test_valuesR

            if not calibrated:
                pupil_x_coords.append(normalized_pupil_x)
                pupil_y_coords.append(normalized_pupil_y)
                r_pupil_x_coords.append(rnormalized_pupil_x)
                r_pupil_y_coords.append(rnormalized_pupil_y)

                print(f'Pupil_x_coords: {pupil_x_coords}')

                count += 1
                print(f'Count: {count}')

                if count == 100:
                    times += 1
                    emit('time_data', {'times': times})
                    print(f'Times: {times}')
                    count = 0

                if times == 5:
                    # Perform final calibration
                    pupil_poly_x = poly.fit_transform(np.array(pupil_x_coords).reshape(-1, 1))
                    pupil_poly_y = poly.fit_transform(np.array(pupil_y_coords).reshape(-1, 1))
                    pupil_poly_rx = poly.fit_transform(np.array(r_pupil_x_coords).reshape(-1, 1))
                    pupil_poly_ry = poly.fit_transform(np.array(r_pupil_y_coords).reshape(-1, 1))

                    margin_x, margin_y = 30, 30
                    rep_times = 100


                    model_x = LinearRegression().fit(pupil_poly_x, (np.concatenate((np.full(rep_times, margin_x), 
                                                                                np.full(rep_times, frame_width-margin_x),
                                                                                np.full(rep_times, margin_x),
                                                                                np.full(rep_times, frame_width-margin_x),
                                                                                np.full(rep_times, frame_width//2)))).reshape(-1, 1))
                    
                    model_y = LinearRegression().fit(pupil_poly_y, (np.concatenate((np.full(rep_times, margin_y), 
                                                                                np.full(rep_times, margin_y),
                                                                                np.full(rep_times, frame_height-margin_y),
                                                                                np.full(rep_times, frame_height-margin_y),
                                                                                np.full(rep_times, frame_height//2)))).reshape(-1, 1))
                    
                    model_rx = LinearRegression().fit(pupil_poly_rx, (np.concatenate((np.full(rep_times, margin_x), 
                                                                                np.full(rep_times, frame_width-margin_x),
                                                                                np.full(rep_times, margin_x),
                                                                                np.full(rep_times, frame_width-margin_x),
                                                                                np.full(rep_times, frame_width//2)))).reshape(-1, 1))
                    
                    model_ry = LinearRegression().fit(pupil_poly_ry, (np.concatenate((np.full(rep_times, margin_y), 
                                                                                np.full(rep_times, margin_y),
                                                                                np.full(rep_times, frame_height-margin_y),
                                                                                np.full(rep_times, frame_height-margin_y),
                                                                                np.full(rep_times, frame_height//2)))).reshape(-1, 1))

                    calibrated = True
                    times = 0

            if calibrated:
                gaze_point = map_pupil_to_screen((normalized_pupil_x, normalized_pupil_y), 
                                                 (rnormalized_pupil_x, rnormalized_pupil_y), 
                                                 frame_width, frame_height)
                gaze_x = gaze_point[0]
                gaze_y = gaze_point[1]

                if isinstance(gaze_x, np.ndarray):
                    gaze_x = gaze_x[0]
                if isinstance(gaze_y, np.ndarray):
                    gaze_y = gaze_y[0]

                print(f'Gaze Values: ({gaze_x}, {gaze_y})')

                emit('gaze_data', {'gaze_x': gaze_x, 'gaze_y': gaze_y})

                cv2.circle(frame, (int(gaze_point[0]), int(gaze_point[1])), 30, (0, 255, 0), 30)

            left_eye_blink = get_Blinking([33, 160, 158, 133, 153, 144], landmarks)
            right_eye_blink = get_Blinking([362, 385, 387, 263, 373, 380], landmarks)
            avg_eye_blink = (left_eye_blink + right_eye_blink) / 2
            is_blinking = avg_eye_blink <= 0.25

            _, buffer = cv2.imencode('.jpg', frame)
            processed_image = base64.b64encode(buffer).decode('utf-8')

            filename = 'processed_image.jpg'
            filepath = os.path.join(UPLOAD_FOLDER, filename)
            cv2.imwrite(filepath, frame)

            # emit({
            #     'output': 'Processed image saved',
            #     'image_url': f'/show_image/{processed_image}',
            #     'calibrated': calibrated,
            #     'gaze_point': gaze_point if calibrated else None,
            #     'is_blinking': is_blinking,
            #     'calibration_progress': f'{times}/5' if not calibrated else 'Complete'
            # })
            # return
    emit('error', {'error': 'No face detected'})

@app.route('/show_image/<filename>')
def show_image(filename):
    return send_file(os.path.join(UPLOAD_FOLDER, filename), mimetype='image/jpeg')

if __name__ == '__main__':
    socketio.run(app, debug=True, host='0.0.0.0', port=5000, allow_unsafe_werkzeug=True)