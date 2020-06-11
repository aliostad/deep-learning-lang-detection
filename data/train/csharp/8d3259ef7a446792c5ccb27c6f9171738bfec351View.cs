using UnityEngine;
using System.Collections;

public abstract class View : MonoBehaviour
{
    private Model _Model;
    private Controller _Controller;

    public Controller Controller
    {
        get { return _Controller; }
        set { _Controller = value;  }
    }

    public Model Model
    {
        get { return _Model; }
        set { _Model = value; }
    }

    public Controller GetController() { return _Controller; }
    public void SetController(Controller controller) { _Controller = controller; }
    public Model GetModel() { return _Model; }
    public void SetModel(Model model) { _Model = model; }
}
