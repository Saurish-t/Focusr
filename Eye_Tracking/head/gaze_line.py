import cv2
import numpy as np
from eye.eye import Find_Full_Eye_Region

left_eye_points = [33, 160, 158, 133, 153, 144]
right_eye_points = [362, 385, 387, 263, 373, 380]

def draw_gaze_line(frame, pupil_center, landmarks, max_length=5):
    _, left_eye_x, left_eye_y, left_eye_w, left_eye_h = Find_Full_Eye_Region(left_eye_points, landmarks, frame)
    
    left_eye_bound = left_eye_x
    right_eye_bound = left_eye_x + left_eye_w
    top_eye_bound = left_eye_y
    bottom_eye_bound = left_eye_y + left_eye_h
    
    left_distance = pupil_center[0] - left_eye_bound
    right_distance = right_eye_bound - pupil_center[0]
    
    top_distance = pupil_center[1] - top_eye_bound
    bottom_distance = bottom_eye_bound - pupil_center[1]
    
    horizontal_gaze_ratio = ((left_distance - right_distance) / (right_eye_bound - left_eye_bound))
    vertical_gaze_ratio = ((top_distance - bottom_distance) / (bottom_eye_bound - top_eye_bound))
    
    threshold = 0.02
    if abs(horizontal_gaze_ratio) < threshold:
        horizontal_gaze_ratio = 0
    if abs(vertical_gaze_ratio) < threshold:
        vertical_gaze_ratio = 0
    
    horizontal_gaze_ratio = int(max(min(horizontal_gaze_ratio, 1), -1) * 100)
    vertical_gaze_ratio = int(max(min(vertical_gaze_ratio, 1), -1) * 100)
    
    norm = np.linalg.norm([horizontal_gaze_ratio, vertical_gaze_ratio])
    line_length = norm * max_length
    
    if norm == 0:
        gaze_end_point = pupil_center 
    else:
        gaze_direction = np.array([horizontal_gaze_ratio, vertical_gaze_ratio]) / norm
        
        gaze_end_point = (
            int(pupil_center[0] + gaze_direction[0] * line_length),
            int(pupil_center[1] + gaze_direction[1] * line_length)
        )

    if line_length > 0:
        cv2.line(frame, pupil_center, gaze_end_point, (0, 255, 0), 2)
        cv2.circle(frame, gaze_end_point, 5, (0, 0, 255), -1)  
    else:
        cv2.circle(frame, pupil_center, 5, (255, 0, 0), -1) 

    cv2.circle(frame, (left_eye_bound, top_eye_bound + int(left_eye_h / 2)), 3, (255, 255, 255), 1)
    cv2.circle(frame, (right_eye_bound, top_eye_bound + int(left_eye_h / 2)), 3, (255, 255, 255), 1)
    cv2.circle(frame, (left_eye_bound + int(left_eye_w / 2), top_eye_bound), 3, (255, 255, 255), 1)
    cv2.circle(frame, (left_eye_bound + int(left_eye_w / 2), bottom_eye_bound), 3, (255, 255, 255), 1)

    print(f'Pupil center: {pupil_center}, Gaze ratios: ({horizontal_gaze_ratio}, {vertical_gaze_ratio}), Line length: {line_length}, End point: {gaze_end_point}')
    print(f'Top Distance: {top_distance}')
    print(f'Bottom Distance: {bottom_distance}')
    print(f'Left distance: {left_distance}')
    print(f"Right Distance: {right_distance}")
    cv2.putText(frame, f'Pupil center: {pupil_center}, Gaze ratios: ({horizontal_gaze_ratio}, {vertical_gaze_ratio})', (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 0, 255), 2)

    _, right_eye_x, right_eye_y, right_eye_w, right_eye_h = Find_Full_Eye_Region(right_eye_points, landmarks, frame)
    
    right_left_eye_bound = right_eye_x
    right_right_eye_bound = right_eye_x + right_eye_w
    right_top_eye_bound = right_eye_y
    right_bottom_eye_bound = right_eye_y + right_eye_h
    
    right_left_distance = pupil_center[0] - right_left_eye_bound
    right_right_distance = right_right_eye_bound - pupil_center[0]
    
    right_top_distance = pupil_center[1] - right_top_eye_bound
    right_bottom_distance = right_bottom_eye_bound - pupil_center[1]
    
    right_horizontal_gaze_ratio = ((right_left_distance - right_right_distance) / (right_right_eye_bound - right_left_eye_bound))
    right_vertical_gaze_ratio = ((right_top_distance - right_bottom_distance) / (right_bottom_eye_bound - right_top_eye_bound))
    
    if abs(right_horizontal_gaze_ratio) < threshold:
        right_horizontal_gaze_ratio = 0
    if abs(right_vertical_gaze_ratio) < threshold:
        right_vertical_gaze_ratio = 0
    
    right_horizontal_gaze_ratio = int(max(min(right_horizontal_gaze_ratio, 1), -1) * 100)
    right_vertical_gaze_ratio = int(max(min(right_vertical_gaze_ratio, 1), -1) * 100)
    
    right_norm = np.linalg.norm([right_horizontal_gaze_ratio, right_vertical_gaze_ratio])
    right_line_length = right_norm * max_length
    
    if right_norm == 0:
        right_gaze_end_point = pupil_center 
    else:
        right_gaze_direction = np.array([right_horizontal_gaze_ratio, right_vertical_gaze_ratio]) / right_norm
        
        right_gaze_end_point = (
            int(pupil_center[0] + right_gaze_direction[0] * right_line_length),
            int(pupil_center[1] + right_gaze_direction[1] * right_line_length)
        )

    if right_line_length > 0:
        cv2.line(frame, pupil_center, right_gaze_end_point, (0, 255, 0), 2)
        cv2.circle(frame, right_gaze_end_point, 5, (0, 0, 255), -1)  
    else:
        cv2.circle(frame, pupil_center, 5, (255, 0, 0), -1) 

    cv2.circle(frame, (right_left_eye_bound, right_top_eye_bound + int(right_eye_h / 2)), 3, (255, 255, 255), 1)
    cv2.circle(frame, (right_right_eye_bound, right_top_eye_bound + int(right_eye_h / 2)), 3, (255, 255, 255), 1)
    cv2.circle(frame, (right_left_eye_bound + int(right_eye_w / 2), right_top_eye_bound), 3, (255, 255, 255), 1)
    cv2.circle(frame, (right_left_eye_bound + int(right_eye_w / 2), right_bottom_eye_bound), 3, (255, 255, 255), 1)

    print(f'Right Eye Gaze ratios: ({right_horizontal_gaze_ratio}, {right_vertical_gaze_ratio}), Line length: {right_line_length}, End point: {right_gaze_end_point}')
    print(f'Right Top Distance: {right_top_distance}')
    print(f'Right Bottom Distance: {right_bottom_distance}')
    print(f'Right Left distance: {right_left_distance}')
    print(f"Right Right Distance: {right_right_distance}")
    cv2.putText(frame, f'Right Eye Gaze ratios: ({right_horizontal_gaze_ratio}, {right_vertical_gaze_ratio})', (50, 100), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 0, 255), 2)
