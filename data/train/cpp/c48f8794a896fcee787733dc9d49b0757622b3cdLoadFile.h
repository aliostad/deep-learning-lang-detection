
#ifndef  _LOAD_FILE_H_
#define  _LOAD_FILE_H_

#include "cocos2d.h"

namespace ModelViewer
{

class LoadFile
{
public:
	static LoadFile* getInstance( void);

	/**
	 *	Modelディレクトリに存在する3Dモデルファイルをすべて読み込み
	 *
	 *	@return 読み込み成功 true : 失敗 false
	 */
	bool loadModelDirectory( void);

	/**
	 *	読み込んだ3Dモデルの情報を取得する
	 *
	 *	@param 取得したいモデルの番号 
	 *	(アルファベット順に読み込まれるので Aに近いほど 0に近い)
	 *	@return 生成済みSprite3Dインスタンスへのポインタ
	 */
	cocos2d::Sprite3D* getModelData( int searchCount);

	/**
	 *	表示中のモデルのファイル名を取得
	 *
	 *	@return ファイル名 (拡張子抜き)
	 */
	std::string getModelName( void);

	/**
	 *	表示中のモデルのアニメーションを再生
	 */
	void startModelAnime( void);

	/**
	 *	表示中のモデルのアニメーションを停止
	 */
	void stopModelAnime( void);

private:
	LoadFile();
	LoadFile( const LoadFile& p) = delete;
	LoadFile& operator=( const LoadFile& P) = delete;
	~LoadFile();

	class Private;
	Private *p;
};

}

#endif // _LOAD_FILE_H_