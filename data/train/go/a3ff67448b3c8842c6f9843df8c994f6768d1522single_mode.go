package store

import "yunxindao/msg"
import "yunxindao/db"

//SingleMode &&
type SingleMode struct {
	OverDispatch      ModeDispatch
	OverFilterTargets ModeFilterTargets
}

//Dispatch &&
func (mode *SingleMode) Dispatch(store *StateStoreRegistry, fromPartnerInfoItem *PartnerInfoItem, sessionItem *SessionItem, msg msg.Msg, toPartnerInfoItems map[uint64]*PartnerInfoItem) {
	if mode.OverDispatch != nil {
		mode.OverDispatch(db.ChannelMultiMode, store, fromPartnerInfoItem, sessionItem, msg, toPartnerInfoItems)
	}
}

//type ModeFilterTargets func(int, uint64, msg msg.Msg, channelPartners map[uint64]*ChannelItemPartner) map[uint64]*ChannelItemPartner
//FilterTargets &&
func (mode *SingleMode) FilterTargets(fromPartnerInfoItem *PartnerInfoItem, sessionItem *SessionItem, channel *ChannelInfoItem, msgBody msg.Msg) map[uint64]*PartnerInfoItem {
	if mode.OverFilterTargets != nil {
		return mode.OverFilterTargets(db.ChannelMultiMode, fromPartnerInfoItem, sessionItem, channel, msgBody)
	}
	return nil
}
