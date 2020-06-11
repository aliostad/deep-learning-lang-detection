/*!
 * @brief	スキンモデルデータのハンドルクラス。
 */
#pragma once

namespace tkEngine{
	class CSkinModel;
	typedef std::shared_ptr<CSkinModelData> CSkinModelDataPtr;
	/*!
	* @brief	CSkinModelDataのハンドルクラス。
	*/
	class CSkinModelDataHandle : Noncopyable{
		std::shared_ptr<CSkinModelData> m_originalSkinModelData;	//!<オリジナルのスキンモデルデータ。
		std::unique_ptr<CSkinModelData> m_skinModelData;								//!<スキンモデルデータ。
	public:
		
		/*!
		 * @brief	CSkinModelDataの生ポインタを取得。
		 */
		CSkinModelData* GetBody()
		{
			if(m_skinModelData){
				return m_skinModelData.get();
			}
			return m_originalSkinModelData.get();
		}
		/*!
		 * @brief	初期化。
		 *@details
		 * CSkinModelDataResourcesから呼ばれます。ユーザーは使用しないように。
		 */
		void Init(const std::shared_ptr<CSkinModelData>& skinModelData, CAnimation* anim, bool isClone);
	};
}
