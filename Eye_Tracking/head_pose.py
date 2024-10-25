import numpy as np
import cv2
from scipy.spatial.transform import Rotation as R

def get_head_pose(landmarks, frame_shape):
    size = frame_shape
    image_points = np.array([
        (landmarks[1][0], landmarks[1][1]),    # Nose tip
        (landmarks[159][0], landmarks[159][1]),  # Chin
        (landmarks[33][0], landmarks[33][1]),  # Left eye left corner
        (landmarks[263][0], landmarks[263][1]),  # Right eye right corner
        (landmarks[362][0], landmarks[362][1]),  # Left mouth corner
        (landmarks[0][0], landmarks[0][1])  # Right mouth corner
    ], dtype="double")
    model_points = np.array([
        (0.0, 0.0, 0.0),             # Nose tip
        (0.0, -330.0, -65.0),        # Chin
        (-225.0, 170.0, -135.0),     # Left eye left corner
        (225.0, 170.0, -135.0),      # Right eye right corner
        (-150.0, -150.0, -125.0),    # Left mouth corner
        (150.0, -150.0, -125.0)      # Right mouth corner
    ])
    focal_length = size[1]
    center = (size[1]/2, size[0]/2)
    camera_matrix = np.array(
        [[focal_length, 0, center[0]],
         [0, focal_length, center[1]],
         [0, 0, 1]], dtype="double"
    )
    dist_coeffs = np.zeros((4, 1))  
    success, rotation_vector, translation_vector = cv2.solvePnP(model_points, image_points, camera_matrix, dist_coeffs, flags=cv2.SOLVEPNP_ITERATIVE)
    rotation_matrix, _ = cv2.Rodrigues(rotation_vector)
    r = R.from_matrix(rotation_matrix)
    angles = r.as_euler('xyz', degrees=True)
    return angles
