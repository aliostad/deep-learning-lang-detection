#include "MeasureModel.h"


MeasureModel::MeasureModel(Matrix h, Matrix r): H(h), R(r)
{
}

MeasureModel::MeasureModel(const MeasureModel &m):H(m.H), R(m.R)
{

}

// Destructor
MeasureModel::~MeasureModel()
{

}

void MeasureModel::UpdateModel(Matrix h, Matrix r)
{
	H = h;
	R = r;
}

void MeasureModel::SetH(Matrix h)
{
	H = h;
}

Matrix MeasureModel::GetH()
{
	return H;
}

void MeasureModel::SetR(Matrix r)
{
	R = r;
}

Matrix MeasureModel::GetR()
{
	return R;
}

MeasureModel MeasureModel::getModel()
{
    Matrix h(9, 9, 0.0), r(9, 9, 0.0);
    h[0][0] = 1;
    h[1][1] = 1;
    h[2][2] = 1;
    h[3][3] = 1;
    h[4][4] = 1;
    h[5][5] = 1;
    h[6][6] = 1;
    h[7][7] = 1;
    h[8][8] = 1;
    r.unit();
	MeasureModel model(h, r);
	return model;
}
