import numpy as np
import cv2
from eye.eye import Find_Full_Eye_Region

font = cv2.FONT_HERSHEY_PLAIN

def find_Gaze(points, landmarks, threshold_value, blur_value, frame):
    eye_crop, min_x, min_y, w, h = Find_Full_Eye_Region(points, landmarks, frame)

    cv2.imshow("Eye_Cutout", eye_crop)
    origin = (min_x, min_y)

    eye_crop_gray = cv2.cvtColor(eye_crop, cv2.COLOR_BGR2GRAY)
    cv2.imshow("Grayscale_cutout", eye_crop_gray)

    blurred_eye = cv2.GaussianBlur(eye_crop_gray, (5, 5), 0)
    cv2.imshow("Blurred eye", blurred_eye)

    # kernal = np
    # eroded_eye = cv2.erode()
    
    _, threshold_eye = cv2.threshold(blurred_eye, threshold_value, 255, cv2.THRESH_BINARY_INV)
    kernel = np.ones((3, 3), np.uint8)
                           
    cv2.imshow("Thresholded Eye", threshold_eye) 

    threshold_eye = cv2.morphologyEx(threshold_eye, cv2.MORPH_CLOSE, kernel)  
    threshold_eye = cv2.morphologyEx(threshold_eye, cv2.MORPH_OPEN, kernel)  
    
    cv2.imshow("Thresholded Eye", threshold_eye) 

    contours, _ = cv2.findContours(threshold_eye, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)

    pupil_center = (0, 0)
    absolute_pupil_center = (0, 0)  
    normalized_x, normalized_y = 0, 0  

    if len(contours) > 0:
        try:
            largest_contour = max(contours, key=cv2.contourArea)
            M = cv2.moments(largest_contour)
            if M["m00"] != 0:
                cX = int(M["m10"] / M["m00"])
                cY = int(M["m01"] / M["m00"])
                pupil_center = (cX, cY)

                normalized_x = (cX / eye_crop.shape[1])
                normalized_y = (cY / eye_crop.shape[0])

                absolute_pupil_center = (min_x + cX, min_y + cY)
                print(f'Absolute_pupil_center {absolute_pupil_center}')
                cv2.circle(frame, absolute_pupil_center, 1, (0, 255, 255), -1)
                cv2.circle(eye_crop, (cX, cY), 1, (0, 255, 255), -1)

                cv2.drawContours(eye_crop, [largest_contour], -1, (0, 255, 255), 1)
                cv2.imshow("Eye Contour", eye_crop)

            else:
                cv2.putText(frame, "No Pupil Detected", (50, 300), font, 2, (255, 0, 0), 3)
        except (IndexError, ZeroDivisionError):
            cv2.putText(frame, "Error in Pupil Detection", (50, 300), font, 2, (255, 0, 0), 3)

    height, width = threshold_eye.shape
    left_side_threshold = threshold_eye[0:height, 0:int(width/2)]
    left_side_white = cv2.countNonZero(left_side_threshold)

    right_side_threshold = threshold_eye[0:height, int(width/2):width]
    right_side_white = cv2.countNonZero(right_side_threshold)

    if right_side_white == 0:
        gaze_ratio = 100 
    else:
        gaze_ratio = (left_side_white / (left_side_white + right_side_white)) * 100

    return gaze_ratio, pupil_center, absolute_pupil_center, (normalized_x, normalized_y)
