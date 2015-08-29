#pragma once
/*****************************************/
/*
*/
/*****************************************/

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
    float fWeight;     //对应该项功能的权重
};

class CCosmeticEngine
{
public:
    /*!
    @brief: get one cosmetic engine instance.
    @return: null, initialize failed, or else, get one cosmetic engine instance.
    */
     static CCosmeticEngine* GetInstanse(void);

    /*!
    @brief: release the specified engine object.
    @param pObj: the engine object to be freed
    @return: false, release failed, or else, release successful.
    */
     static bool ReleaseInstance(CCosmeticEngine*& pObj);

public:
    /*!
    @brief: initialize the cosmetic engine.
    @param width: the width of image to be processed.
    @param height: the height of image to be processed.
    @return: 
    1.	set parameter successful
    2.	failed, not enough memory or other program error
    3.	failed, engine data format error
    4.	failed, face engine data problem, face engine data version less than the supporting version
    5.	failed, face engine data problem, face engine data version larger than the supporting version
    */
    virtual int Initialize(int width, int height, const unsigned char* pEngineData,
        int lenData) = 0;

    /*!
    @brief: release all resources occupied by engine.
    @return:1, release successful, 2, failed.
    */
    virtual int Uninitialize(void) = 0;

    /*!
    @brief: set which function of the engine will be opened.
    @param pTempData: the template data buffer to be refreshed.
    @param lenModel: the length of model data buffer
    @param nFormat: 0 for android, 1 for ios
    @return:
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
    virtual int SetCosmeticParam(const CosmeticTemplateData* pTempData, int lenModel, int nFormat) = 0;

    /*!
    @brief: set the camera angle
    @param nRotate: the rotate angle, the angle represent the direction of camera
    @return: 1, set the angle successful, 2, failed.
    */
    virtual int SetRotate(int nRotate) = 0;

    /*!
    @brief: set beauty parameter
    @param: beautyParam, the face beauty parameter buffer
    @param: len, the length of face beauty parameter buffer
    @return:1, set parameter successful, 0, set parameter failed.
    */
    virtual int SetBeautyParam(const BeautyParam* beautyParam, int len) = 0;

    /*!
    @brief: make-up according to video image.
    @param pYuv: the original YUV format image data.
    @param width: the width of image.
    @param height: the height of image.
    @param pYuvRet: the final processed image data(YUV format).
    @return:  1, make-up successful. 2, make-up failed
    */
    virtual int RealCosmeticByVideo(const unsigned char* pYuv, int width, int height,
        unsigned char* pYuvRet, const float* pRealParam, int lenParam) = 0;

    /*!
    @brief: make-up according to static image.
    @param pYuv: the original YUV format image data.
    @param width: the width of image.
    @param height: the height of image.
    @param pYuvRet: the final processed image data(YUV format).
    @return: 1, make-up successful. 2, make-up failed
    */
    virtual int StaticCosmeticByImage(const unsigned char* pYuv, int width, int height, 
        unsigned char* pYuvRet, const float* pRealParam, int lenParam) = 0;
};
