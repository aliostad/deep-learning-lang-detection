package nozomi.nzmlib.regression.impl

import breeze.linalg.DenseVector
import org.scalatest.FlatSpec

/**
  * Created by ariwaranosai on 16/3/2.
  *
  */

class GLMRegressionModelTest extends FlatSpec {

    "model" should "the same" in {
        val path = "/tmp/tmp.txt"
        val weight = DenseVector[Double](2,4,1,5,0,9)
        val intercept = 3.45
        GLMRegressionModel.SaveLoad.save(path, "trivalModel", weight, intercept)
        val load = GLMRegressionModel.SaveLoad.load(path, "trivalModel", 6)

        import GLMRegressionModel.SaveLoad._

        val data = Data(weight, intercept)

        assert(data == load)
    }

}
