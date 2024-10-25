from flask import Flask, request, jsonify, send_file
import cv2
import numpy as np
import os

app = Flask(__name__)

UPLOAD_FOLDER = 'received_images'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

@app.route('/upload_image', methods=['POST'])
def upload_image():
    print("Request received")
    print(f"Content-Type: {request.content_type}")
    print(f"Files: {request.files}")
    
    if 'image' not in request.files:
        return jsonify({'error': 'No image file in request'}), 400
    
    try:
        file = request.files['image']
        
        file_bytes = file.read()
        
        nparr = np.frombuffer(file_bytes, np.uint8)
        
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
        
        if img is None:
            return jsonify({'error': 'Failed to decode image'}), 400

        height, width = img.shape[:2]

        filename = 'received_image.jpg'
        filepath = os.path.join(UPLOAD_FOLDER, filename)
        cv2.imwrite(filepath, img)

        return jsonify({
            'output': f'Received and saved image of size {width}x{height}',
            'image_url': f'/show_image/{filename}'
        })
    except Exception as e:
        print(f"Error processing image: {str(e)}")
        return jsonify({'error': f'Error processing image: {str(e)}'}), 500

@app.route('/show_image/<filename>')
def show_image(filename):
    return send_file(os.path.join(UPLOAD_FOLDER, filename), mimetype='image/jpeg')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)