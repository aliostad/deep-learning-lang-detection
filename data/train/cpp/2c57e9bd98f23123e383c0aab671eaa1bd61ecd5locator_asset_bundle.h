#ifndef _CHAOS3D_ASSET_LOCATOR_ASSET_BUNDLE_H
#define _CHAOS3D_ASSET_LOCATOR_ASSET_BUNDLE_H

#include <memory>
#include <forward_list>
#include "asset/asset_bundle.h"
#include "asset/asset_locator.h"

// The asset bundle from the given path(locator) and the
// extension for a particular file type
// This is a helper bundle for the assets from the files of
// the same type (.png); this may only produce one type
// of resources (texture). The file type itself can be
// a meta or produce several types of resources as well.
class locator_asset_bundle : public asset_bundle {
public:
    /// destructor to remove dependencies on member variables
    virtual ~locator_asset_bundle();

    /// construct from a root dir
    locator_asset_bundle(asset_locator::ptr const& locator,
                         loaders_t && loaders,
                         context const&);

    asset_locator::ptr const& locator() const { return _locator;}
    virtual std::string name() const override { return _locator->name(); }
    
private:
    // load asset meta: name -> handle
    void load_assets();

    asset_locator::ptr _locator;

    // TODO: preallocate the loaders to the assets?
};

// TODO: asset handle factory based on type (extension or
// info in the .meta?), so the locator bundle can be load
// from a list of files
#endif