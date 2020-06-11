namespace GoneBananas

open System
open System.Collections.Generic
open CocosDenshion
open CocosSharp
open System.Linq

open Box2D.Common
open Box2D.Dynamics
open Box2D.Collision.Shapes



type GameLayer() as this =
    inherit CCLayerColor()

    let MONKEY_SPEED = 350.0f
    let GAME_DURATION = 60.0f // game ends after 60 seconds or when the monkey hits a ball, whichever comes first
    // point to meter ratio for physics
    let PTM_RATIO = 32.f

    let mutable elapsedTime = 0.f
    [<DefaultValue>] val mutable monkey:CCSprite
    let mutable visibleBananas = new List<CCSprite> ()
    let mutable hitBananas = new List<CCSprite> ()
    // monkey walking animation
    [<DefaultValue>] val mutable walkAnim:CCAnimation
    [<DefaultValue>] val mutable walkRepeat:CCRepeatForever
    let mutable walkAnimStop = new CCCallFuncN ( fun node -> node.StopAllActions ())
    // background sprite
    [<DefaultValue>] val mutable grass:CCSprite
    // particles
    [<DefaultValue>] val mutable sun:CCParticleSun
    // circle layered behind sun
    [<DefaultValue>] val mutable circleNode:CCDrawNode
    // parallax node for clouds
    [<DefaultValue>] val mutable parallaxClouds:CCParallaxNode 
    // define our banana rotation action
    let mutable rotateBanana = new CCRotateBy(0.8f, 360.f)
    // define our completion action to remove the banana once it hits the bottom of the screen
    let mutable moveBananaComplete = new CCCallFuncN ( fun node -> node.RemoveFromParent ())
    // physics world
    [<DefaultValue>] val mutable world:b2World 
    // balls sprite batch
    let mutable ballsBatch = new CCSpriteBatchNode ("balls", 100)
    let mutable ballTexture= ballsBatch.Texture

    let AddGrass() =
        this.grass <- new CCSprite ("grass")
        this.AddChild (this.grass)

    let AddSun () =
        this.circleNode <- new CCDrawNode ()
        this.circleNode.DrawSolidCircle (CCPoint.Zero, 30.0f, CCColor4B.Yellow)
        this.AddChild(this.circleNode :> CCNode )

        this.sun <- new CCParticleSun (CCPoint.Zero)
        this.sun.StartColor <- new CCColor4F (CCColor3B.Red)
        this.sun.EndColor <- new CCColor4F (CCColor3B.Yellow)
        this.AddChild (this.sun :> CCNode )


    let AddMonkey () =
        let spriteSheet = new CCSpriteSheet ("animations/monkey.plist")
        let animationFrames = spriteSheet.Frames.FindAll ( fun x -> x.TextureFilename.StartsWith ("frame"))
        this.walkAnim <- new CCAnimation (animationFrames, 0.1f);
        this.walkRepeat <- new CCRepeatForever (new CCAnimate (this.walkAnim))
        this.monkey <- new CCSprite (animationFrames.First (), Name = "Monkey" )
        this.monkey.Scale <- 0.25f
        this.AddChild (this.monkey)


    let GetRandomPosition (spriteSize:CCSize) = 
        let rnd = float32 (CCRandom.NextDouble()) 
        let randomX = 
            if rnd > 0.0f then 
                rnd * this.VisibleBoundsWorldspace.Size.Width - spriteSize.Width / 2.0f
            else    
                spriteSize.Width / 2.0f
        new CCPoint ( randomX, this.VisibleBoundsWorldspace.Size.Height - spriteSize.Height / 2.0f )

    let AddBanana () =
        let spriteSheet = new CCSpriteSheet ("animations/monkey.plist")
        let banana = new CCSprite (spriteSheet.Frames.Find ( fun x -> x.TextureFilename.StartsWith ("Banana")))
        let p = GetRandomPosition (banana.ContentSize)
        banana.Position <- p
        banana.Scale <- 0.5f

        this.AddChild (banana)

        let moveBanana = new CCMoveTo (5.0f, new CCPoint (banana.Position.X, 0.0f))
        banana.RunActions (moveBanana, moveBananaComplete) |> ignore
        banana.RepeatForever (rotateBanana) |> ignore

        banana

    let ShouldEndGame() = elapsedTime > GAME_DURATION

    let EndGame () =
        let gameOverScene = GameOverLayer.SceneWithScore (this.Window, hitBananas.Count)
        let transitionToGameOver = new CCTransitionMoveInR (0.3f, gameOverScene)
        this.Director.ReplaceScene (transitionToGameOver)

    let AddBall() =
        let idx = if CCRandom.Float_0_1 () > 0.5f then 0 else 1
        let idy = if CCRandom.Float_0_1 () > 0.5f then 0 else 1
        let rect = Nullable<CCRect> (new CCRect(float32(32 * idx), float32(32 * idy), 32.f, 32.f))
        let sprite = new CCPhysicsSprite (ballTexture, rect, float PTM_RATIO)

        ballsBatch.AddChild (sprite);

        let p = GetRandomPosition (sprite.ContentSize)

        sprite.Position <- new CCPoint (p.X, p.Y);

        let def = 
            new b2BodyDef (
                position = new b2Vec2 (p.X / PTM_RATIO, p.Y / PTM_RATIO),
                ``type`` = b2BodyType.b2_dynamicBody )
        let body = this.world.CreateBody (def)

        let circle = new b2CircleShape (Radius = 0.5f)

        let fd = 
            new b2FixtureDef ( 
                shape = circle ,
                density = 1.0f ,
                restitution = 0.85f ,
                friction = 0.3f )
        body.CreateFixture (fd) |> ignore
        sprite.PhysicsBody <- body
        Console.WriteLine ("sprite batch node count = {0}", ballsBatch.ChildrenCount);

    let MoveClouds (dy:float32) =
        this.parallaxClouds.StopAllActions ()
        let moveClouds = new CCMoveBy (1.0f, new CCPoint (0.f, dy * 0.1f))
        this.parallaxClouds.RunAction (moveClouds) |> ignore

    let OnTouchesEnded (touches:List<CCTouch>) (touchEvent:CCEvent) =
        this.monkey.StopAllActions ()

        let mutable location = touches.[0].LocationOnScreen
        location <- this.WorldToScreenspace (location);  //Layer.WorldToScreenspace(location); 
        let ds = CCPoint.Distance (this.monkey.Position, location)
        let dt = ds / MONKEY_SPEED
        let moveMonkey = new CCMoveTo (dt, location)
        //BUG: calling walkRepeat separately as it doesn't run when called in RunActions or CCSpawn
        this.monkey.RunAction (this.walkRepeat) |> ignore
        this.monkey.RunActions (moveMonkey, walkAnimStop) |> ignore
        // move the clouds relative to the monkey's movement
        MoveClouds (location.Y - this.monkey.Position.Y) 

    let Explode ( pt:CCPoint) =
        let explosion = new CCParticleExplosion (pt); //TODO: manage "better" for performance when "many" particles
        explosion.TotalParticles <- 10;
        explosion.AutoRemoveOnFinish <- true
        this.AddChild (explosion)


    let CheckCollision () =
        for banana in visibleBananas do
            let hit = banana.BoundingBoxTransformedToParent.IntersectsRect (this.monkey.BoundingBoxTransformedToParent)
            if hit then 
                hitBananas.Add (banana)
                CCSimpleAudioEngine.SharedEngine.PlayEffect ("Sounds/tap") |> ignore
                Explode (banana.Position)
                banana.RemoveFromParent ()
        for banana in hitBananas do
            visibleBananas.Remove (banana) |> ignore

        let ballHitCount = ballsBatch.Children.Where( fun ball -> 
            ball.BoundingBoxTransformedToParent.IntersectsRect( 
                                        this.monkey.BoundingBoxTransformedToParent )).Count()
        if ballHitCount > 0 then
            EndGame ()

    let AddClouds() =
        let h = this.VisibleBoundsWorldspace.Size.Height 

        this.parallaxClouds <- new CCParallaxNode(
            Position = new CCPoint (0.f, h))
        this.AddChild (this.parallaxClouds)

        let cloud1 = new CCSprite ("cloud")
        let cloud2 = new CCSprite ("cloud")
        let cloud3 = new CCSprite ("cloud")

        let yRatio1 = 1.0f
        let yRatio2 = 0.15f
        let yRatio3 = 0.5f

        this.parallaxClouds.AddChild (cloud1, 0, new CCPoint (1.0f, yRatio1), new CCPoint (100.f, -100.f + h - (h * yRatio1)));
        this.parallaxClouds.AddChild (cloud2, 0, new CCPoint (1.0f, yRatio2), new CCPoint (250.f, -200.f + h - (h * yRatio2)));
        this.parallaxClouds.AddChild (cloud3, 0, new CCPoint (1.0f, yRatio3), new CCPoint (400.f, -150.f + h - (h * yRatio3)));

    let InitPhysics () = 
        let s = this.Layer.VisibleBoundsWorldspace.Size
        
        let gravity = new b2Vec2 (0.0f, -10.0f)
        this.world <- new b2World (gravity)

        this.world.SetAllowSleeping (true)
        this.world.SetContinuousPhysics (true)

        let def = new b2BodyDef ()
        def.allowSleep <- true
        def.position <- b2Vec2.Zero
        def.``type`` <- b2BodyType.b2_staticBody
        let groundBody = this.world.CreateBody (def)
        groundBody.SetActive (true)

        let groundBox = new b2EdgeShape ()
        groundBox.Set (b2Vec2.Zero, new b2Vec2 (s.Width / (float32 PTM_RATIO), 0.f));
        let fd = new b2FixtureDef()
        fd.shape <- groundBox
        groundBody.CreateFixture (fd)



    do 
        let touchListener = new CCEventListenerTouchAllAtOnce ()
        touchListener.OnTouchesEnded <- fun t e -> OnTouchesEnded t e
        this.AddEventListener (touchListener, this)
        this.Color <- new CCColor3B (CCColor4B.White)
        this.Opacity <- byte 255
        // batch node for physics balls
        this.AddChild( ballsBatch :> CCNode , 1, 1 )
        AddGrass()
        AddSun ()
        AddMonkey ()

        this.Schedule((fun t -> 
                    visibleBananas.Add ( AddBanana ())
                    elapsedTime <- elapsedTime  + t
                    if ShouldEndGame () then
                        EndGame ()
                    AddBall ()), 
                    1.0f )

        this.Schedule (fun t -> CheckCollision ())

        this.Schedule (
            fun t -> 
                    this.world.Step (t, 8, 1)
                    for it in ballsBatch.Children do
                        let sprite = it :?> CCPhysicsSprite
                        if sprite.Visible && sprite.PhysicsBody.Position.x < 0.f || 
                           sprite.PhysicsBody.Position.x * PTM_RATIO > this.ContentSize.Width then
                            //or should it be Layer.VisibleBoundsWorldspace.Size.Width
                            this.world.DestroyBody (sprite.PhysicsBody)
                            sprite.Visible <- false;
                            sprite.RemoveFromParent ()
                        else
                            sprite.UpdateTransformedSpriteTextureQuads ()
        )

    override this.AddedToScene () =
        base.AddedToScene ()

        this.Scene.SceneResolutionPolicy <- CCSceneResolutionPolicy.NoBorder

        this.grass.Position <- this.VisibleBoundsWorldspace.Center
        this.monkey.Position <- this.VisibleBoundsWorldspace.Center

        let b = this.VisibleBoundsWorldspace
        this.sun.Position <- b.UpperRight.Offset (-100.f, -100.f); //BUG: doesn't appear in visible area on Nexus 7 device

        this.circleNode.Position <- this.sun.Position;

        AddClouds ();


    override this.OnEnter () =
        base.OnEnter ()
        InitPhysics () |> ignore

    static member GameScene (mainWindow:CCWindow) =
        let scene = new CCScene (mainWindow)
        let layer = new GameLayer ()
        scene.AddChild (layer)
        scene

and
    GameOverLayer(score:int) as this =
    inherit CCLayerColor()

    let mutable scoreMessage = System.String.Empty

    do 
        let touchListener = new CCEventListenerTouchAllAtOnce ()
        touchListener.OnTouchesEnded <- fun touches ccevent -> this.Window.DefaultDirector.ReplaceScene (GameLayer.GameScene (this.Window))
        this.AddEventListener (touchListener, this)
        scoreMessage <- String.Format ("Game Over. You collected {0} bananas!", score)
        this.Color <- new CCColor3B (CCColor4B.Black)
        this.Opacity <- byte 255

    member this.AddMonkey () =
        let spriteSheet = new CCSpriteSheet ("animations/monkey.plist")
        let frame = spriteSheet.Frames.Find ( fun x -> x.TextureFilename.StartsWith ("frame"))
           
        let monkey = 
            new CCSprite (frame, 
                Position = 
                    new CCPoint (this.VisibleBoundsWorldspace.Size.Center.X + 20.f, 
                        this.VisibleBoundsWorldspace.Size.Center.Y + 300.f),
                Scale = 0.5f )
        this.AddChild (monkey)

    override this.AddedToScene () =
        base.AddedToScene ()
        this.Scene.SceneResolutionPolicy <- CCSceneResolutionPolicy.ShowAll

        let scoreLabel = 
            new CCLabelTtf (scoreMessage, "arial", 22.f, 
                Position = new CCPoint (this.VisibleBoundsWorldspace.Size.Center.X, this.VisibleBoundsWorldspace.Size.Center.Y + 50.f),
                Color = new CCColor3B (CCColor4B.Yellow),
                HorizontalAlignment = CCTextAlignment.Center,
                VerticalAlignment = CCVerticalTextAlignment.Center,
                AnchorPoint = CCPoint.AnchorMiddle,
                Dimensions = this.ContentSize )
        this.AddChild (scoreLabel);

        let playAgainLabel = 
            new CCLabelTtf ("Tap to Play Again", "arial", 22.f, 
                Position = this.VisibleBoundsWorldspace.Size.Center,
                Color = new CCColor3B (CCColor4B.Green),
                HorizontalAlignment = CCTextAlignment.Center,
                VerticalAlignment = CCVerticalTextAlignment.Center,
                AnchorPoint = CCPoint.AnchorMiddle,
                Dimensions = this.ContentSize )

        this.AddChild (playAgainLabel);

        this.AddMonkey ()

    static member SceneWithScore ((mainWindow:CCWindow), (score:int))  =
        let scene = new CCScene (mainWindow)
        let layer = new GameOverLayer (score)
        scene.AddChild (layer)
        scene;
