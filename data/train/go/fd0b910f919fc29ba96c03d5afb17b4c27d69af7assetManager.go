package assets

// AssetManager manages engine resources.
type AssetManager struct {
	sm ShaderManager
	tm TextureManager
}

// NewAssetManager creates a new AssetManager to handle shader and texture assets.
func NewAssetManager() *AssetManager {
	am := AssetManager{
		sm: newShaderManager(),
		tm: newTextureManager(),
	}
	return &am
}

// Shaders retrieves the ShaderManager.
func (am *AssetManager) Shaders() ShaderManager {
	return am.sm
}

// Textures retrieves the TextureManager.
func (am *AssetManager) Textures() TextureManager {
	return am.tm
}
