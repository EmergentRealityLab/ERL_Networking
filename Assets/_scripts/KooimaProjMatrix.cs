using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class KooimaProjMatrix : MonoBehaviour {
	
	public Transform BottomLeftScreenCorner;
	public Transform BottomRightScreenCorner;
	public Transform TopLeftScreenCorner;
	
	
	public enum eyeOffset{left, right};
	public eyeOffset whichEyeIfStereo = eyeOffset.left;
	
	Vector3 trackerPosition;
	bool stereo;
	float interpupillaryDistance;
	
	public void LateUpdate () {
		Camera cam = camera;
		
		//get new tracker position (as updated over the network)
		//getting it off the "ViewUpdate" component on the projection root (parent), along with IPD if needed
		trackerPosition = transform.parent.GetComponent<ViewUpdate>().trackerPosition;
		stereo = transform.parent.GetComponent<ViewUpdate>().stereo;
		interpupillaryDistance = transform.parent.GetComponent<ViewUpdate>().interpupillaryDistance;
		
		if (stereo){
			if (whichEyeIfStereo == eyeOffset.left)
				trackerPosition.x -= interpupillaryDistance/2;
			else
				trackerPosition.x += interpupillaryDistance/2;
		}
		
		
    	Matrix4x4 generatedProjection = KooimaPerspectiveProjection(
                BottomLeftScreenCorner.localPosition, BottomRightScreenCorner.localPosition, 
                TopLeftScreenCorner.localPosition, trackerPosition, 
                cam.nearClipPlane, cam.farClipPlane);
    	cam.projectionMatrix = generatedProjection;   
}
	
	public Matrix4x4 KooimaPerspectiveProjection(Vector3 bottomLeft, Vector3 bottomRight, Vector3 topLeft, Vector3 eyePos, float near, float far){
        Vector3 eyeToScreenBottomLeft, eyeToScreenBottomRight, eyeToScreenTopLeft;
        Vector3 orthoR, orthoU, orthoN;

        float left, right, bottom, top, eyedistance;     

        Matrix4x4 transformMatrix;
        Matrix4x4 projectionM;
        Matrix4x4 eyeTranslateM;
        Matrix4x4 finalProjection;
		
		//Deal with reversed Z for left-handed coordinate system
		bottomLeft.z = -bottomLeft.z;
		bottomRight.z = -bottomRight.z;
		topLeft.z = -topLeft.z;
		eyePos.z = -eyePos.z;

        ///Calculate the orthonormal basis for the screen
        orthoR = bottomRight - bottomLeft;
        orthoR.Normalize();
        orthoU = topLeft - bottomLeft;
        orthoU.Normalize();
        orthoN = Vector3.Cross(orthoR, orthoU);
        orthoN.Normalize();

        //Screen corner vecs (frustum extent)
        eyeToScreenBottomLeft = bottomLeft-eyePos;
        eyeToScreenBottomRight = bottomRight-eyePos;
        eyeToScreenTopLeft = topLeft-eyePos;

        //Distance from the eye to the screen plane
        eyedistance = -(Vector3.Dot(eyeToScreenBottomLeft, orthoN));

        //Extent of the perpendicular projection
        left = (Vector3.Dot(orthoR, eyeToScreenBottomLeft)*near)/eyedistance;
        right  = (Vector3.Dot(orthoR, eyeToScreenBottomRight)*near)/eyedistance;
        bottom  = (Vector3.Dot(orthoU, eyeToScreenBottomLeft)*near)/eyedistance;
        top = (Vector3.Dot(orthoU, eyeToScreenTopLeft)*near)/eyedistance;

        //"Load" projection using Unity's oblique projection
        projectionM = PerspectiveOffCenter(left, right, bottom, top, near, far);

        //Fill in the transform matrix with the orthonormal basis
        transformMatrix = new Matrix4x4();
		transformMatrix = Matrix4x4.identity;
        transformMatrix[0, 0] = orthoR.x;
        transformMatrix[0, 1] = orthoR.y;
        transformMatrix[0, 2] = orthoR.z;
        transformMatrix[1, 0] = orthoU.x;
        transformMatrix[1, 1] = orthoU.y;
        transformMatrix[1, 2] = orthoU.z;
        transformMatrix[2, 0] = orthoN.x;
        transformMatrix[2, 1] = orthoN.y;
        transformMatrix[2, 2] = orthoN.z;
		
        //Apex of frustum to eye transform
        eyeTranslateM = new Matrix4x4();
		eyeTranslateM = Matrix4x4.identity;
        eyeTranslateM[0, 3] = -eyePos.x;
        eyeTranslateM[1, 3] = -eyePos.y;
        eyeTranslateM[2, 3] = -eyePos.z;
        
        //Concatenate everything
        finalProjection = new Matrix4x4();
        finalProjection = Matrix4x4.identity * projectionM * transformMatrix * eyeTranslateM;

        return finalProjection;
    }

	static Matrix4x4 PerspectiveOffCenter(float left, float right, float bottom, float top, float near, float far) {
		
		/*
		 the classic projection matrix, generalized to allow off-center viewing
		 
		 2n/(r-l)	0			(r+l)/(r-l)		0
		 0			2n/(t-b)	(t+b)/(t-b)		0
		 0			0			-(f+n)/(f-n)	-2nf/(f-n)
		 0			0			-1				0
		 */

		Matrix4x4 m = new Matrix4x4();
		m = Matrix4x4.identity;
        m[0, 0] = 2.0F * near / (right - left);
        m[0, 2] = (right + left) / (right - left);
        m[1, 1] = 2.0F * near / (top - bottom);
        m[1, 2] = (top + bottom) / (top - bottom);
        m[2, 2] = -(far + near) / (far - near);
        m[2, 3] = -(2.0F * far * near) / (far - near);
        m[3, 2] = -1.0f;
        m[3, 3] = 0;
        return m;
    }
}
