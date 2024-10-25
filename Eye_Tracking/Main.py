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

mp_face_mesh = mp.solutions.face_mesh
face_mesh = mp_face_mesh.FaceMesh(static_image_mode=False, max_num_faces=1, min_detection_confidence=0.5)
pupil_positions = []
cap = cv2.VideoCapture(0)
points = [33, 160, 158, 133, 153, 144]
rpoints = [362, 385, 387, 263, 373, 380]

scaler = StandardScaler()


alpha = 0.2 
ema_pupil_x, ema_pupil_y = None, None

plt.ion()
fig, ax = plt.subplots(figsize=(8, 8))
scatter_points = [None] * 5
prediction_dot = None



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
    
    scaled_x = int(predicted_x * screen_width / screen_width) 
    scaled_y = int(predicted_y * screen_height / screen_height)

    return scaled_x, scaled_y





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

def get_Normalized_Pupil_Position(pupil_center, x, y, w, h):
    pupil_x = pupil_center[0]
    pupil_y = pupil_center[1]
    
    eye_width = w
    eye_height = h
    
    if eye_width == 0 or eye_height == 0:
        return (0, 0) 

    normalized_pupil_x = (pupil_x - x) / eye_width
    normalized_pupil_y = (pupil_y - y) / eye_height
    
    return normalized_pupil_x, normalized_pupil_y



font = cv2.FONT_HERSHEY_PLAIN

count = 0
times = 0
pupil_coord_model_train = []
pupil_x_coords = []
pupil_y_coords = []
r_pupil_x_coords = []
r_pupil_y_coords = []
dot_colors = [(0, 0, 255), (0, 0, 255), (0, 0, 255), (0, 0, 255), (0, 0, 255)]
calibrated = False
avgX = 0
avgY = 0
avgXr = 0
avgYr = 0
normalized_pupil_positions = []
normalized_x_values = []
normalized_y_values = []
normalized_xr_values = []
normalized_yr_values = []
def nothing(x):
    pass

cv2.namedWindow("Frame", cv2.WND_PROP_FULLSCREEN)
cv2.setWindowProperty("Frame", cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)


cv2.createTrackbar("Threshold", "Frame", 110, 255, nothing)
cv2.createTrackbar("Blur_value", "Frame", 3, 30, nothing)

pupil_x_buffer = []
pupil_y_buffer = []
pupil_xr_buffer = []
pupil_yr_buffer = []



while True:
    _, frame = cap.read()
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

    results = face_mesh.process(rgb_frame)
    frame_height, frame_width = frame.shape[:2]

    margin_x = 30 
    margin_y = 30  
    
    if results.multi_face_landmarks:
        for face_landmarks in results.multi_face_landmarks:
            landmarks = [(int(lm.x * frame.shape[1]), int(lm.y * frame.shape[0])) for lm in face_landmarks.landmark]

            eye, min_x, min_y, max_x, max_y = Find_Full_Eye_Region(points, landmarks, frame)
            eyer, xr, yr, wr, hr = Find_Full_Eye_Region(rpoints, landmarks, frame)
            print(f"min_x: {min_x}, max_x: {max_x}, min_y: {min_y}, max_y: {max_y}")

            angles = get_head_pose(landmarks, frame.shape)
            pitch, yaw, roll = angles

            left_eye_blink = get_Blinking([33, 160, 158, 133, 153, 144], landmarks)
            right_eye_blink = get_Blinking([362, 385, 387, 263, 373, 380], landmarks)

            avgEyeBlink = (left_eye_blink + right_eye_blink) / 2

            if avgEyeBlink <= 0.25:
                cv2.putText(frame, "BLINKING", (50, 300), font, 2, (255, 0, 0), 3)

            threshold_value = cv2.getTrackbarPos("Threshold", "Frame")
            blur_value = cv2.getTrackbarPos("Blur_value", "Frame")

            gaze_ratioL, eye_origin, pupil_center, test_values = find_Gaze(points, landmarks, threshold_value, blur_value, frame)
            gaze_ratioR, eye_originR, pupil_centerR, test_valuesR = find_Gaze(rpoints, landmarks, threshold_value, blur_value, frame)

            print(f'Pupil center: {pupil_center}')

            if pupil_center != (0, 0):
                # normalized_pupil_x, normalized_pupil_y = get_Normalized_Pupil_Position(pupil_center, min_x, min_y, max_x, max_y)
                # rnormalized_pupil_x, rnormalized_pupil_y = get_Normalized_Pupil_Position(pupil_centerR, xr, yr, wr, hr)
                normalized_pupil_x, normalized_pupil_y = pupil_center
                rnormalized_pupil_x, rnormalized_pupil_y = pupil_centerR
                normalized_pupil_x /= frame_width
                normalized_pupil_y /= frame_height
                rnormalized_pupil_x /= frame_width
                rnormalized_pupil_y /= frame_height
                print(f'Normalized Pupil Center: {(normalized_pupil_x, normalized_pupil_y)}')
                print(f'Right Normalized Pupil Center: {(rnormalized_pupil_x, rnormalized_pupil_y)}')

                cv2.putText(frame, f'Pupil Center L: {(normalized_pupil_x, normalized_pupil_y)}', (int(frame_width/10), int(frame_height/3)), font, 1, (0, 0, 255), 2)
                cv2.putText(frame, f'Pupil Center R: {(rnormalized_pupil_x, rnormalized_pupil_y)}', (int(frame_width/10), int(frame_height/3+20)), font, 1, (0, 0, 255), 2)
                print(f'Test Values: {test_values}')
                cv2.putText(frame, str(test_values), (500, 100), font, 2, (0, 0, 255), 3)



                normalized_pupil_x = test_values[0]
                normalized_pupil_y = test_values[1]
                rnormalized_pupil_x = test_valuesR[0]
                rnormalized_pupil_y = test_valuesR[1]
                
                print(f'normalized_pupil_x {test_values[0]}')
                print(f'normalized_pupil_x {test_values[1]}')
                print(f'normalized_pupil_x {test_valuesR[0]}')
                print(f'normalized_pupil_x {test_valuesR[1]}')


                new_dot_colors = (0, 255, 0)

                pupil_x_buffer.append(normalized_pupil_x)
                pupil_y_buffer.append(normalized_pupil_y)
                pupil_xr_buffer.append(rnormalized_pupil_x)
                pupil_yr_buffer.append(rnormalized_pupil_y)

                normalized_x_values.append(normalized_pupil_x)
                normalized_y_values.append(normalized_pupil_y)
                normalized_xr_values.append(rnormalized_pupil_x)
                normalized_yr_values.append(rnormalized_pupil_y)


                if count == 250 and times < 5 and not calibrated:
                    # normalized_x_values = np.array(pupil_x_buffer)
                    # normalized_y_values = np.array(pupil_y_buffer)
                    # normalized_xr_values = np.array(pupil_xr_buffer)
                    # normalized_yr_values = np.array(pupil_yr_buffer)

                    print(f'Normalized_x_values: {normalized_x_values}')

                    # pupil_x_coords[times] = normalized_x_values
                    # pupil_y_coords[times] = normalized_y_values
                    # r_pupil_x_coords[times] = normalized_xr_values
                    # r_pupil_y_coords[times] = normalized_yr_values

                    pupil_x_coords.append(normalized_x_values)
                    pupil_y_coords.append(normalized_y_values)
                    r_pupil_x_coords.append(normalized_xr_values)
                    r_pupil_y_coords.append(normalized_yr_values)

                    print(f'Pupil_x_coords: {pupil_x_coords}')
                    
                    print(f"Finished Spot {times}")
                    dot_colors[times] = new_dot_colors

                    times += 1
                    count = 0

                    print(f'Buffer Before: {pupil_x_buffer} ------ {pupil_y_buffer}')

                    pupil_x_buffer = []
                    pupil_y_buffer = []
                    pupil_xr_buffer = []
                    pupil_yr_buffer = []

                    print(f'Buffer After: {pupil_x_buffer} ------ {pupil_y_buffer}')


                if times == 5 and not calibrated:
                    print(normalized_pupil_positions)
                    poly = PolynomialFeatures(1)
                    
                    screen_coords = np.array([
                        [margin_x, frame_height - margin_y],  # Bottom left
                        [frame_width - margin_x, frame_height - margin_y],  # Bottom right
                        [margin_x, margin_y],  # Top left
                        [frame_width - margin_x, margin_y],  # Top right
                        [frame_width // 2, frame_height // 2]  # Center
                    ]).flatten()

                    target_screen_coords = []

                    print(f"Length of pupil_x_coords: {len(pupil_x_coords[0]), len(pupil_x_coords[1]), len(pupil_x_coords[2]), len(pupil_x_coords[3]), len(pupil_x_coords[4])}")
                    print(f"Length of pupil_y_coords: {len(pupil_y_coords[0]), len(pupil_y_coords[1]), len(pupil_y_coords[2]), len(pupil_y_coords[3]), len(pupil_y_coords[4])}")
                    print(f"Length of pupil_y_coords: {len(r_pupil_x_coords[0]), len(r_pupil_x_coords[1]), len(r_pupil_x_coords[2]), len(r_pupil_x_coords[3]), len(r_pupil_x_coords[4])}")
                    print(f"Length of pupil_y_coords: {len(r_pupil_y_coords[0]), len(r_pupil_y_coords[1]), len(r_pupil_y_coords[2]), len(r_pupil_y_coords[3]), len(r_pupil_y_coords[4])}")
                    
                    print(f"Length of screen_coords: {len(screen_coords)}")
                
                    print(f"Pupil y_coords {pupil_y_coords}")
                    
                    pupil_x_coords = pupil_x_coords[0][1:]
                    pupil_y_coords = pupil_y_coords[0][1:]
                    r_pupil_x_coords = r_pupil_x_coords[0][1:]
                    r_pupil_y_coords = r_pupil_y_coords[0][1:]

                    pupil_x_coords = np.array(pupil_x_coords).flatten().reshape(-1, 1)
                    pupil_y_coords = np.array(pupil_y_coords).flatten().reshape(-1, 1)
                    r_pupil_x_coords = np.array(pupil_x_coords).flatten().reshape(-1, 1)
                    r_pupil_y_coords = np.array(pupil_x_coords).flatten().reshape(-1, 1)

                    print(f"Shape of pupil_x_coords: {pupil_x_coords.shape}")
                    print(f"Shape of pupil_y_coords: {pupil_y_coords.shape}")

                    # pupil_positions_poly_final = np.hstack((
                    #     poly.fit_transform(np.array(pupil_x_coords)),
                    #     poly.fit_transform(np.array(pupil_y_coords))
                    # ))

                    # pupil_positions_poly_finalr = np.hstack((
                    #     poly.fit_transform(np.array(r_pupil_x_coords)),
                    #     poly.fit_transform(np.array(r_pupil_y_coords))
                    # ))

                    pupil_poly_x = poly.fit_transform(np.array(pupil_x_coords))
                    pupil_poly_y = poly.fit_transform(np.array(pupil_x_coords))
                    pupil_poly_rx = poly.fit_transform(np.array(pupil_x_coords))
                    pupil_poly_ry = poly.fit_transform(np.array(pupil_x_coords))

                    print(f'Transformed pupil x: {pupil_poly_x}')
                    print(f'Transformed pupil y {pupil_poly_y}')
                    print(f'Transformed pupil rx: {pupil_poly_rx}')
                    print(f'Transformed pupil ry: {pupil_poly_ry}')

                    pupil_x_coords = pupil_x_coords[1:]
                    pupil_y_coords = pupil_y_coords[1:]
                    r_pupil_x_coords = r_pupil_x_coords[1:]
                    r_pupil_y_coords = r_pupil_y_coords[1:]

                    print(f'Transformed pupil x shape: {pupil_poly_x.shape}')
                    print(f'Transformed pupil y shape: {pupil_poly_y.shape}')
                    print(f'Transformed pupil rx shape: {pupil_poly_rx.shape}')
                    print(f'Transformed pupil ry shape: {pupil_poly_ry.shape}')


                    rep_times = 250

                    temp = (np.concatenate((np.full(rep_times, margin_x), 
                                            np.full(rep_times, frame_width-margin_x),
                                            np.full(rep_times, margin_x),
                                            np.full(rep_times, frame_width-margin_x),
                                            np.full(rep_times, frame_width//2))).reshape(-1, 1))
                    print(f'temp shape: {temp.shape}')
                    print(f"Temp: {temp}")


                    # print(f'Pupil_positions {pupil_positions_poly_final}')
                    # print(f'Shape {pupil_positions_poly_final.shape}')
                    # print(f'Length {len(pupil_positions_poly_final)}')

                    # model = LinearRegression().fit(pupil_positions_poly_final, screen_coords)
                    # modelr = LinearRegression().fit(pupil_positions_poly_finalr, screen_coords)

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



                    # fig, axes = plt.subplots(2, 2, figsize=(15, 10))

                    # axes[0, 0].scatter(pupil_x_coords, target_screen_coords[:, 0], color='blue', label='Left Pupil X vs Screen X')
                    # axes[0, 0].set_title('Left Pupil X vs Screen X')
                    # axes[0, 0].set_xlabel('Pupil X Position')
                    # axes[0, 0].set_ylabel('Screen X Position')
                    # axes[0, 0].legend()

                    # axes[0, 1].scatter(pupil_y_coords, target_screen_coords[:, 1], color='green', label='Left Pupil Y vs Screen Y')
                    # axes[0, 1].set_title('Left Pupil Y vs Screen Y')
                    # axes[0, 1].set_xlabel('Pupil Y Position')
                    # axes[0, 1].set_ylabel('Screen Y Position')
                    # axes[0, 1].legend()

                    # axes[1, 0].scatter(r_pupil_x_coords, target_screen_coords[:, 0], color='red', label='Right Pupil X vs Screen X')
                    # axes[1, 0].set_title('Right Pupil X vs Screen X')
                    # axes[1, 0].set_xlabel('Pupil X Position')
                    # axes[1, 0].set_ylabel('Screen X Position')
                    # axes[1, 0].legend()

                    # axes[1, 1].scatter(r_pupil_y_coords, target_screen_coords[:, 1], color='orange', label='Right Pupil Y vs Screen Y')
                    # axes[1, 1].set_title('Right Pupil Y vs Screen Y')
                    # axes[1, 1].set_xlabel('Pupil Y Position')
                    # axes[1, 1].set_ylabel('Screen Y Position')
                    # axes[1, 1].legend()

                    # plt.tight_layout()
                    # plt.show()



                count += 1


                circle_positions = [
                    (margin_x, margin_y),                          # Top left
                    (frame_width - margin_x, margin_y),           # Top right
                    (frame_width // 2, frame_height // 2),        # Center
                    (margin_x, frame_height - margin_y),          # Bottom left
                    (frame_width - margin_x, frame_height - margin_y)  # Bottom right
                ]

                for i, (x, y) in enumerate(circle_positions):
                    cv2.circle(frame, (x, y), 10, dot_colors[i], 10)


    cv2.putText(frame, f"FINISHED SPOT {times}", (50, 300), font, 2, (255, 0, 0), 3)

    if calibrated and pupil_center != (0, 0):
        gaze_point = map_pupil_to_screen((normalized_pupil_x, normalized_pupil_y), (rnormalized_pupil_x, rnormalized_pupil_y), frame_width, frame_height)
        print(gaze_point)
        lookX = gaze_point[0]
        lookY = gaze_point[1]

        print(f'Gaze_Values: {lookX, lookY}')

        cv2.circle(frame, (int(lookX), int(lookY)), 30, (0, 255, 0), 30)
    cv2.imshow("Frame", frame)

    key = cv2.waitKey(1)
    if key == 27:
        break

cap.release()
cv2.destroyAllWindows()
plt.tight_layout()
plt.show()


