#pragma once


enum FaceBeautifyID
{
	BEAUTIFY_BUFFING_FACE = 0, //磨皮功能ID
	BEAUTIFY_WHITEN_FACE  //美白功能ID
};

struct CosmeticTemplateData
{
	unsigned char* pData;
	int lenData;
	unsigned int bgr;//(a << 24 |b << 16 | g << 8 | r)
};

struct BeautyParam
{
	int id;                 //美颜ID
	float fWeight;     //对应该项功能的权重,范围[0,1.0f]
};

class CCosmetic3DTryonEngine
{
public:
	static CCosmetic3DTryonEngine* GetInstance(void);

	static bool ReleaseInstance(CCosmetic3DTryonEngine*& obj);

	virtual ~CCosmetic3DTryonEngine() {};

public:
    /*!
	@brief: initialize the engine
	@param pModelBuf:				[in] the initializing model data buffer
	@param nModelSize:			[in] the length of the initializing model data
	@param width:						the width of image to be processed.
	@param height:						the height of image to be processed.
	@param glassfitting_param: the glass fitting init parameter.
	@param typeOS					the os type: android or IOS
	@return: 
	1.	init successful
	2.	failed, not enough memory or other memory error
	3.	failed, face_all_data_100.dat format error
	4.	failed, face engine data problem, face engine data version less than the supporting version
	5.	failed, face engine data problem, face engine data version larger than the supporting version
	6. failed, glass fitting module initialize error
	7. failed, cosmetic module initialize error
    */
	virtual int Initialize(unsigned char *pModelBuf, int nModelSize, int wd, int ht, int glassfitting_param, int typeOS) = 0;
	
	 /*!
	 @brief: release the engine.
	 @return :
	 1. release successful
	 other. release failed
     */
	virtual int Uninitialize() = 0;

	 /*!
    @brief: set the camera angle
    @param nRotate: the rotate angle, the angle represent the direction of camera
    @return:
	1. set the angle successful
	0. failed
    */
	virtual int SetRotate(int nRotate) = 0;

	 /*!
    @brief: set which cosmetic function of the engine will be opened.
    @param pTempData: the cosmetic template data buffer to be refreshed.
    @param lenModel: the length of model data buffer
	@return:
	0. the engine has not been initialized or the formal parameter error
	1.	set parameter successful
	2.	failed, not enough memory or other program error
	3.	failed, template format error
	4.	failed, mouth template problem, mouth template data version less than the supporting version
	5.	failed, mouth template problem, mouth template data version larger than the supporting version
	6.	failed, pupil template problem, pupil template data version less than the supporting version
	7.	failed, pupil template problem, pupil template data version larger than the supporting version
	8.	failed, up eyelash template problem, up eyelash template data version less than the supporting version
	9.	failed, up eyelash template problem, up eyelash template data version larger than the supporting version
	10.	failed, eyeshadow template problem, eyeshadow template data version less than the supporting version
	11.	failed, eyeshadow template problem, eyeshadow template data version larger than the supporting version
	12.	failed, up eye line template problem, up eye line template data version less than the supporting version
	13.	failed, up eye line template problem, up eye line template data version larger than the supporting version
	14.	failed, blusher template problem, blusher template data version less than the supporting version
	15.	failed, blusher template problem, blusher template data version larger than the supporting version
	16.	failed, foundation template problem, foundation template data version less than the supporting version
	17.	failed, foundation template problem, foundation template data version larger than the supporting version
	18.	failed, down eyelash template problem, down eyelash template data version less than the supporting version
	19.	failed, down eyelash template problem, down eyelash template data version larger than the supporting version
	20.	failed, down eye line template problem, down eye line template data version less than the supporting version
	21.	failed, down eye line template problem, down eye line template data version larger than the supporting version
	22.	failed, both eye line template problem, both eye line template data version less than the supporting version
	23.	failed, both eye line template problem, both eye line template data version larger than the supporting version
    */
	virtual int Cosmetic_SetCosmeticParam(const CosmeticTemplateData* pTempData, int lenModel) = 0;

	/*!
    @brief: set beauty parameter
    @param: beautyParam, the face beauty parameter buffer
    @param: len, the length of face beauty parameter buffer
    @return:
	1. set parameter successful
	0. set parameter failed.
    */
	virtual int Cosmetic_SetBeautyParam(const BeautyParam* beautyParam, int len) = 0;

	/*!
	@brief: reset the background image for glass fitting
	@param  pBkYuv:		[in] the YUV format background image data buffer
	@param  nWidth:		[in] the width of the image
	@param  nHeight:		[in] the height of the image
	@return
	1. successful
	2. failed, engine has not been initialized
	3. failed, image buffer error
	*/
	virtual int GlassFitting_SetBkImage(unsigned char *pBkYuv, int nBkWd, int nBkHt)= 0;

	/*!
	@brief: reset the glass model data for glass fitting
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
	virtual int GlassFitting_SetGlassModel(unsigned char *pModelBuf, int nModelSize)= 0;

	/*!
	@brief:	cosmetic and glass fitting by the video frame
	@param  pYuvRet:					[in,out] the YUV format image data buffer
	@param  nWidth:					[in] the width of the image
	@param  nHeight:					[in] the height of the image
	@param  bCostemtic:			[in] show cosmetic result or not
	@param  pCosmeticParam:	[in] the cosmetic parameters
	@param  lenParam:				[in] the number of the cosmetic parameters
	@param  bGlassFitting:			[in] show glass fitting result or not
	@param  fTheta:					[in] the glass rotation angles // (0-10 degree) //
	@return :
	1. successful
	2. failed, face location module error
	3. failed, cosmetic module error
	4. failed, glass fitting module error
	*/
	virtual int CosmeticAndGlassFittingByVideo(
		unsigned char *pYuvRet, int nWidth, int nHeight, 
		bool bCostemtic, float* pCosmeticParam, int lenParam,
		bool bGlassFitting, float fTheta) = 0;

	/*!
	@brief:	cosmetic and glass fitting by the static image
	@param  pYuvRet:					[in,out] the YUV format image data buffer
	@param  nWidth:					[in] the width of the image
	@param  nHeight:					[in] the height of the image
	@param  bCostemtic:			[in] show cosmetic result or not
	@param  pCosmeticParam:	[in] the cosmetic parameters
	@param  lenParam:				[in] the number of the cosmetic parameters
	@param  bGlassFitting:			[in] show glass fitting result or not
	@param  fTheta:					[in] the glass rotation angles // (0-10 degree) //
	@return :
	1. successful
	2. failed, face location module error
	3. failed, cosmetic module error
	4. failed, glass fitting module error
	*/
	virtual int CosmeticAndGlassFittingByPicture(
		unsigned char *pYuvRet, int nWidth, int nHeight, 
		bool bCostemtic, float* pCosmeticParam, int lenParam,
		bool bGlassFitting, float fTheta) = 0;
};
