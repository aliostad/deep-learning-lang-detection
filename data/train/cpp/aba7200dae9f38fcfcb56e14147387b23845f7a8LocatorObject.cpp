#include "PCH.h"
#include "LocatorObject.h"

#include "Util/STG/Locator/Linear.h"
#include "Util/STG/Locator/Rotate.h"
#include "Util/STG/Locator/Trace.h"
#include "Util/STG/Locator/MLLocator.h"

using namespace boost::python;
using namespace Game;
using namespace Util::STG;


void Defs::Util::LocatorObject::Configurate()
{
	class_<Locator::LinearF>( "LocatorLinearF", init<>() )
		.def( init<const Locator::LinearF &>() )
		.def( init<const Vector2DF &>() )
		.def( init<const Vector2DF &, const Vector2DF &, const Vector2DF &>() )
		.def( "update", &Locator::LinearF::Update )
		.def_readwrite( "position", &Locator::LinearF::mPos )
		.def_readwrite( "speed", &Locator::LinearF::mSp )
		.def_readwrite( "accel", &Locator::LinearF::mAc )
		.def( "applyExternalForce", &Locator::LinearF::ApplyExternalForce )
		;
	class_<Locator::RotateF>( "LocatorRotateF", init<>() )
		.def( init<const Locator::RotateF &>() )
		.def( "update", &Locator::RotateF::Update )
		.add_property( "position", &Locator::RotateF::GetPosition )
		.def( "applyExternalForce", &Locator::RotateF::ApplyExternalForce )
		.def_readwrite( "center", &Locator::RotateF::mCenter )
		.def_readwrite( "centerSpeed", &Locator::RotateF::mCenterSp )
		.def_readwrite( "centerAccel", &Locator::RotateF::mCenterAc )
		.add_property( "radius", &Locator::RotateF::GetRadius, &Locator::RotateF::SetRadius )
		.add_property( "radiusSpeed", &Locator::RotateF::GetRadiusSpeed, &Locator::RotateF::SetRadiusSpeed )
		.add_property( "radiusAccel", &Locator::RotateF::GetRadiusAccel, &Locator::RotateF::SetRadiusAccel )
		.add_property( "angle", &Locator::RotateF::GetAngle, &Locator::RotateF::SetAngle )
		.add_property( "angleSpeed", &Locator::RotateF::GetAngleSpeed, &Locator::RotateF::SetAngleSpeed )
		.add_property( "angleAccel", &Locator::RotateF::GetAngleAccel, &Locator::RotateF::SetAngleAccel )
		;
	class_<Locator::TraceF>( "LocatorTraceF", init<>() )
		.def( init<const Locator::TraceF &>() )
		.def( init<float>() )
		.add_property( "tracing", &Locator::TraceF::IsTracing, &Locator::TraceF::SetTracing )
		.def( "update", &Locator::TraceF::Update )
		.def_readwrite( "position", &Locator::TraceF::mPos )
		.def_readwrite( "targetPosition", &Locator::TraceF::mTargetPos )
		.def_readwrite( "speed", &Locator::TraceF::mSp )
		.def_readwrite( "accel", &Locator::TraceF::mAc )
		.add_property( "maxCirclingAngle", &Locator::TraceF::GetMaxCirclingAngle, &Locator::TraceF::SetMaxCirclingAngle )
		.def( "applyExternalForce", &Locator::TraceF::ApplyExternalForce )
		;
	class_<Locator::MLLocator>( "LocatorML", 
		init<Locator::MLLocator::PBMLParser, const Vector2DF &, Game::Util::Random::PRandom>() )
		.def( "update", &Locator::MLLocator::Update )
		.def_readwrite( "locator", &Locator::MLLocator::mLocator )
		.def( "applyExternalForce", &Locator::MLLocator::ApplyExternalForce )
		.add_property( "end", &Locator::MLLocator::IsEnd )
		.add_property( "aimAngle", &Locator::MLLocator::GetAimAngle, &Locator::MLLocator::SetAimAngle )
		.add_property( "rank", &Locator::MLLocator::GetRank, &Locator::MLLocator::SetRank )
		.def_readonly( "defaultRank", &Locator::MLLocator::DEFAULT_RANK )
		;
}