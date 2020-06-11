#pragma once
#ifndef GASHA_INCLUDED_LOAD_TARGET_INL
#define GASHA_INCLUDED_LOAD_TARGET_INL

//--------------------------------------------------------------------------------
// load_target.inl
// ロード対象（部分ロード用）【インライン関数／テンプレート関数定義部】
//
// Gakimaru's standard library for C++ - GASHA
//   Copyright (c) 2014 Itagaki Mamoru
//   Released under the MIT license.
//     https://github.com/gakimaru/gasha_examples/blob/master/LICENSE
//--------------------------------------------------------------------------------

#include "real_test/save_data/load_target.h"//ロード対象（部分ロード用）【宣言部】

GASHA_USING_NAMESPACE;//ネームスペース使用

//--------------------
//ロード対象（部分ロード用）管理クラス

//ロード対象をセット
inline void loadTarget::setLoadTarget(const crc32_t target_name_crc)
{
	m_targetData = target_name_crc;
}

//ロード対象をセット
inline void loadTarget::setLoadTarget(const char* target_name)
{
	setLoadTarget(calcCRC32(target_name));
}

//ロード対象をリセット
inline void loadTarget::resetLoadTarget()
{
	m_targetData = 0;
}

//ロード対象か？
inline bool loadTarget::isLoadTarget(const crc32_t name_crc)
{
	return m_targetData == 0 || m_targetData == name_crc;
}

//ロード対象か？
inline bool loadTarget::isLoadTarget(const char* target_name)
{
	return isLoadTarget(calcCRC32(target_name));
}

//部分ロードか？
inline bool loadTarget::isPartLoad()
{
	return m_targetData != 0;
}

//部分ロードか？かつ、その対象項目か？
inline bool loadTarget::isPartLoad(const crc32_t name_crc)
{
	return isPartLoad() && isLoadTarget(name_crc);
}

//部分ロードか？かつ、その対象項目か？
inline bool loadTarget::isPartLoad(const char* target_name)
{
	return isPartLoad() && isLoadTarget(target_name);
}

#endif//GASHA_INCLUDED_LOAD_TARGET_INL

// End of file
