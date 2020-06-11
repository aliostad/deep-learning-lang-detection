using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NumMethods3
{
    static class PredCorScheme
    {
        public static double[] Solve(PostfixNotation f, double[] x, double y0, double h, int rank)
        {
            double[] y = new double[x.Length];
            y[0] = y0;

            for (int i = 0; i < x.Length - 1; i++)
            {
                //Если треубемый порядок больше, чем пока что вычислено точек,
                if (rank > i + 1)
                {
                    //рассчитываем следующую точку методом меньшего порядка 
                    y[i + 1] = Prediction(f, x, y, h, i, i + 1);
                    y[i + 1] = Correction(f, x, y, h, i, i + 1);
                }
                //Иначе
                else
                {
                    //считаем методом нужного порядка
                    y[i + 1] = Prediction(f, x, y, h, i, rank);
                    y[i + 1] = Correction(f, x, y, h, i, rank);
                }        
            }

            return y;
        }

        //Вычисление предиктора
        private static double Prediction(PostfixNotation f, double[] x, double[] y, double h, int i, int rank)
        {
            switch (rank)
            {
                case 1:
                    return y[i] + h * f.Calculate(x[i], y[i]);
                case 2:
                    return y[i] + (h / 2) * (3 * f.Calculate(x[i], y[i])
                                            - f.Calculate(x[i - 1], y[i - 1]));
                case 3:
                    return y[i] + (h / 12) * (23 * f.Calculate(x[i], y[i])
                                            - 16 * f.Calculate(x[i - 1], y[i - 1])
                                            + 5 * f.Calculate(x[i - 2], y[i - 2]));
                case 4:
                    return y[i] + (h / 24) * (55 * f.Calculate(x[i], y[i])
                                            - 59 * f.Calculate(x[i - 1], y[i - 1])
                                            + 37 * f.Calculate(x[i - 2], y[i - 2])
                                            - 9 * f.Calculate(x[i - 3], y[i - 3]));
                case 5:
                    return y[i] + (h / 720) * (1901 * f.Calculate(x[i], y[i])
                                            - 2774 * f.Calculate(x[i - 1], y[i - 1])
                                            + 2616 * f.Calculate(x[i - 2], y[i - 2])
                                            - 1274 * f.Calculate(x[i - 3], y[i - 3])
                                            + 251 * f.Calculate(x[i - 4], y[i - 4]));
                case 6:
                    return y[i] + (h / 1440) * (4277 * f.Calculate(x[i], y[i])
                                            - 7923 * f.Calculate(x[i - 1], y[i - 1])
                                            + 9982 * f.Calculate(x[i - 2], y[i - 2])
                                            - 7298 * f.Calculate(x[i - 3], y[i - 3])
                                            + 2877 * f.Calculate(x[i - 4], y[i - 4])
                                            - 475 * f.Calculate(x[i - 5], y[i - 5]));
                default:
                    throw new Exception("Метод такого порядка не реализован");
            }
        }

        //Вычисление корректора
        private static double Correction(PostfixNotation f, double[] x, double[] y, double h, int i, int rank)
        {
            switch (rank)
            {
                case 1:
                    return y[i] + h * f.Calculate(x[i + 1], y[i + 1]);
                case 2:
                    return y[i] + (h / 2) * (f.Calculate(x[i + 1], y[i + 1])
                                            + f.Calculate(x[i], y[i]));
                case 3:
                    return y[i] + (h / 12) * (5 * f.Calculate(x[i + 1], y[i + 1])
                                            + 8 * f.Calculate(x[i], y[i])
                                            - f.Calculate(x[i - 1], y[i - 1]));
                case 4:
                    return y[i] + (h / 24) * (9 * f.Calculate(x[i + 1], y[i + 1])
                                            + 19 * f.Calculate(x[i], y[i])
                                            - 5 * f.Calculate(x[i - 1], y[i - 1])
                                            + f.Calculate(x[i - 2], y[i - 2]));
                case 5:
                    return y[i] + (h / 720) * (251 * f.Calculate(x[i + 1], y[i + 1])
                                            + 646 * f.Calculate(x[i], y[i])
                                            - 264 * f.Calculate(x[i - 1], y[i - 1])
                                            + 106 * f.Calculate(x[i - 2], y[i - 2])
                                            - 19 * f.Calculate(x[i - 3], y[i - 3]));
                case 6:
                    return y[i] + (h / 1440) * (475 * f.Calculate(x[i + 1], y[i + 1])
                                            + 1427 * f.Calculate(x[i], y[i])
                                            - 798 * f.Calculate(x[i - 1], y[i - 1])
                                            + 482 * f.Calculate(x[i - 2], y[i - 2])
                                            - 173 * f.Calculate(x[i - 3], y[i - 3])
                                            + 27 * f.Calculate(x[i - 4], y[i - 4]));
                default:
                    throw new Exception("Метод такого порядка не реализован");
            }
        }
    }
}
