namespace Game.Controllers
{
    public class Controller
    {
        public bool Right = false;
        public bool Left = false;
        public bool Up = false;
        public bool Down = false;
        public bool A = false;
        public bool B = false;
        public int Id;

        protected static int ControllerCount = 0;

        public Controller()
        {
            Id = ControllerCount;
            ControllerCount++;
        }

        public void DeepCopy(Controller controller)
        {
            Right = controller.Right;
            Left = controller.Left;
            Up = controller.Up;
            Down = controller.Down;
            A = controller.A;
            B = controller.B;
        }

        public bool Equals(Controller controller)
        {
            if (controller == null)
            {
                return false;
            }
            else
            {
                return (Right != controller.Right || Left != controller.Left || Up != controller.Up || Down != controller.Down || A != controller.A || B != controller.B);
            }
        }
    }
}
