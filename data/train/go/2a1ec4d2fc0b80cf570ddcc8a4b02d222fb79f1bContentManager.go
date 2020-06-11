package Logic

import "github.com/veandco/go-sdl2/sdl"

type ContentManager struct {
	config *Config
	screenInitialResolution Size
	screenResolution Size
}

func NewContentManager(config *Config, initialWidth int, initialHeight int) *ContentManager {
	screenResolution, err := config.GetScreenResolution()
	if err != nil {
		panic(err)
	}
	newContentManager := ContentManager{config, Size{initialWidth, initialHeight}, screenResolution}
	return &newContentManager
}

func (contentManager *ContentManager) ScaleToScreenSize(spriteSize Size) Size {
	scaledSpriteSize := Size{
		contentManager.screenResolution.Width/contentManager.screenInitialResolution.Width*spriteSize.Width,
		contentManager.screenResolution.Height/contentManager.screenInitialResolution.Height*spriteSize.Height,
	}
	return scaledSpriteSize
}

func (contentManager *ContentManager) HorizontalCenter(spriteSize Size) int32 {
	return int32(contentManager.screenResolution.Width/2-spriteSize.Width/2)
}

func (contentManager *ContentManager) VerticalCenter(spriteSize Size) int32 {
	return int32(contentManager.screenResolution.Height/2-spriteSize.Height/2)
}

func (contentManager *ContentManager) ScaleXPositionToScreenSize(x int32) int32 {
	return int32(int(x)*contentManager.screenResolution.Width/contentManager.screenInitialResolution.Width)
}

func (contentManager *ContentManager) ScaleYPositionToScreenSize(y int32) int32 {
	return int32(int(y)*contentManager.screenResolution.Height/contentManager.screenInitialResolution.Height)
}

func (contentManager *ContentManager) GetFullScreenRect() sdl.Rect {
	return sdl.Rect{0, 0, int32(contentManager.screenResolution.Width), int32(contentManager.screenResolution.Height)}
}