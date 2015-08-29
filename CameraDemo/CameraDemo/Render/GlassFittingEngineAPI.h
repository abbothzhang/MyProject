#pragma once

class CGlassFittingEngine
{
public:
	static CGlassFittingEngine* GetInstance(void);

	static bool ReleaseInstance(CGlassFittingEngine*& obj);

	virtual ~CGlassFittingEngine() {};

public:
    /*!
    @brief: initialize the glass try on engine.
    @param pModelBuf: [in] the initializing model data buffer 
    @param nModelSize: [in]the length of the initializing model data
    @param wd: the width of image to be processed.
    @param ht: the height of image to be processed.
	@param typeOS: the OS type of the device, 0 is android, 1 is ios.
    @return: 
    1.	set parameter successful
    2.	failed, not enough memory or other program error
    3.	failed, engine data format error
    4.	failed, face engine data problem, face engine data version less than the supporting version
    5.	failed, face engine data problem, face engine data version larger than the supporting version
    */
	virtual int Initialize(unsigned char *pModelBuf, int nModelSize, int wd, int ht, int glassfittingParam, int typeOS) = 0;
	
	/*!
	 @brief: release the glass try on engine.
	 @return :
	 1. release successful
	 2. release failed
     */
	virtual int Uninitialize() = 0;

     /*!
    @brief: set the camera angle
    @param nRotate: the rotate angle, the angle represent the direction of camera
    @return: 
	1. set the angle successful
	2. failed
    */
    virtual int SetRotate(int nRotate) = 0;
	
    /*!
	 @brief: try on glass based the current image
     @param  pYuvRet:   [in,out] the YUV format image data buffer
     @param  nWidth:    [in] the width of the image
     @param  nHeight:   [in] the height of the image
     @param  fBeta:   [in] the glass rotation angles // (0-10 degree) //
	 @return :
     1. successful
     0. failed
     */
	virtual int GlassFittingByVideo(unsigned char *pYuvRet,int nWidth, int nHeight, float fBeta) = 0;
		
	  /*!
	 @brief: reset the background image 
     @param  pBkYuv:   [in,out] the YUV format background image data buffer
     @param  nWidth:    [in] the width of the image
     @param  nHeight:   [in] the height of the image
	 @return 
     1. successful
     2. failed, engine has not been initialized
	 3. failed, image buffer error
     */
	virtual int ResetBkImage(unsigned char *pBkYuv, int nBkWd, int nBkHt) = 0;

	  /*!
	 @brief: reset the glass model data
     @param pModelBuf: [in] the glass model data buffer
     @param nModelSize: [in]the length of the glass model data
	 @return 
	 1. successful
	 2. failed, engine has not been initialized
	 3. failed, glass model data format error
	 4. failed, glass model version less than the supporting version
	 5. failed, glass model version larger than the supporting version
	 6. failed, not enough memory or other program error
     */
	virtual int ResetGlassModel(unsigned char *pModelBuf, int nModelSize) = 0;
};
