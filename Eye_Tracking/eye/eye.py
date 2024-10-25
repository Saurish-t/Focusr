import numpy as np
import cv2

def Find_Full_Eye_Region(points, landmarks, frame):
    region = np.array([landmarks[point] for point in points], dtype=np.int32)

    height, width = frame.shape[:2]

    mask = np.full((height, width), 255, np.uint8)

    cv2.fillPoly(mask, [region], 0)

    x, y, w, h = cv2.boundingRect(region)
    margin = 5  
    x -= margin
    y -= margin
    w += 2 * margin
    h += 2 * margin

    x = max(x, 0)
    y = max(y, 0)
    w = min(x + w, width) - x
    h = min(y + h, height) - y

    eye_region = frame[y:y+h, x:x+w]

    eye_mask = mask[y:y+h, x:x+w]

    white_background = np.full_like(eye_region, 255)

    eye_region_with_white_background = np.where(eye_mask[:, :, np.newaxis] == 255, white_background, eye_region)

    return eye_region_with_white_background, x, y, w, h