using System;
using System.Threading;

namespace SGT
{
    public partial class Technology
    {
        protected ReaderWriterLockSlim cal_slim = null;           // синхронизатор вычислнения данных

        /// <summary>
        /// Реализует технологию СГТ
        /// </summary>
        public void Calculate(Object sender, CommutatorEventArgs e)
        {
            if (cal_slim.TryEnterWriteLock(50))
            {
                try
                {
                    TechnologyTime = DateTime.Now;
                    InitializeTechData(e.Slice);

                    CalculateSimple(e.Slice, TechnologyTime);
                    CalculateComplex(e.Slice, TechnologyTime);

                    CalculateDrilling(e.Slice, TechnologyTime);

                    TechnologicalStage = p206.Stage;
                    TechnologicalRegime = p206.Regime;

                    TechnologicalHook = p206.Hook;

                    if (onComplete != null)
                    {
                        onComplete(this, EventArgs.Empty);
                    }
                }
                finally
                {
                    cal_slim.ExitWriteLock();
                }
            }
        }

        /// <summary>
        /// Вычислить простые параметры
        /// </summary>
        /// <param name="slice">Срез данных</param>
        /// <param name="curTime">Текущее технологическое время</param>
        protected void CalculateSimple(float[] slice, DateTime curTime)
        {
            p1.Calculate(slice);
            p2.Calculate(slice);

            p3.Calculate(slice);
            p4.Calculate(slice);

            p5.Calculate(slice);

            p6.Calculate(slice);
            p6_1.Calculate(slice);
            p6_2.Calculate(slice);
            p6_3.Calculate(slice);
            p6_4.Calculate(slice);
            p6_5.Calculate(slice);
            p6_6.Calculate(slice);
            p6_7.Calculate(slice);
            p6_8.Calculate(slice);
            p6_9.Calculate(slice);

            p7.Calculate(slice);
            p7_1.Calculate(slice);
            p7_2.Calculate(slice);
            p7_3.Calculate(slice);
            p7_4.Calculate(slice);
            p7_5.Calculate(slice);
            p7_6.Calculate(slice);
            p7_7.Calculate(slice);
            p7_8.Calculate(slice);
            p7_9.Calculate(slice);
            p7_10.Calculate(slice);
            p7_11.Calculate(slice);
            p7_12.Calculate(slice);
            p7_13.Calculate(slice);

            p8.Calculate(slice);
            p8_1.Calculate(slice);

            p9.Calculate(slice);
            p9_1.Calculate(slice);
            p9_2.Calculate(slice);
            p9_3.Calculate(slice);
            p9_4.Calculate(slice);
            p9_5.Calculate(slice);
            p9_6.Calculate(slice);
            p9_7.Calculate(slice);
            p9_8.Calculate(slice);
            p9_9.Calculate(slice);
            p9_10.Calculate(slice);
            p9_11.Calculate(slice);
            p9_12.Calculate(slice);
            p9_13.Calculate(slice);

            p10.Calculate(slice);

            p11.Calculate(slice);
            p11_1.Calculate(slice);

            p12.Calculate(slice);
            p13.Calculate(slice);

            p14.Calculate(slice);
            p14_1.Calculate(slice);

            p15.Calculate(slice);
            p16.Calculate(slice);

            p17.Calculate(slice);
            p18.Calculate(slice);
        }

        /// <summary>
        /// Вычислить комплексные параметры
        /// </summary>
        /// <param name="slice">Срез данных</param>
        /// <param name="curTime">Текущее технологическое время</param>
        protected void CalculateComplex(float[] slice, DateTime curTime)
        {
            p101.Calculate(p2, p16);
            p102.Calculate(p1, p13);

            p103.Calculate(p5, currentTime);
            p104.Calculate(p9, p9_1, p9_2, p9_3, p9_4, p9_5, p9_6, p9_7, p9_8, p9_9, p9_10, p9_11, p9_12, p9_13);

            p105.Calculate(p3);
            p106.Calculate(p104);

            p107.Calculate(p6, p6_1, p6_2, p6_3, p6_4, p6_5, p6_6, p6_7, p6_8, p6_9);
            p108.Calculate(p6, p6_1, p6_2, p6_3, p6_4, p6_5, p6_6, p6_7, p6_8, p6_9);

            p109.Calculate(p8, p8_1, p14, p14_1);
            p110.Calculate(p15, p17, p18);

            p112.Calculate(p11, p11_1, p14, p14_1);
            p113.Calculate(p109, p112);

            p114.Calculate(p10, p113);
            p116.Calculate(p8, p11);

            p117.Calculate(p8_1, p11_1);
            p118.Calculate(p116, p117);
        }

        /// <summary>
        /// Вычислить параметры бурения
        /// </summary>
        /// <param name="slice">Срез данных</param>
        /// <param name="curTime">Текущее технологическое время</param>
        protected void CalculateDrilling(float[] slice, DateTime curTime)
        {
            p200.Calculate(p102);
            p201.Calculate(p4, p12, p102, p200, LockingWeightHook, LockingPressure, TechnologicalRegimeWeightHook);

            p202.Calculate(p5, p102, p12, p204, p205, p203, curTime, LockingWeightHook, 
                size_layout_bottom_column, size_layout_top_column, r_weight);

            p203.Calculate(p202, curTime, SizeLayoutBottomColumn, SizeLayoutTopColumn);

            p204.Calculate(p5, p102, p202, p12, p205, curTime, LockingWeightHook, r_weight);
            p205.Calculate(p204, p202);

            p206.Calculate(p4, p12, p102, p103, p110, p201, p204, p205, curTime,
                LockingWeightHook, IntervalPzr, DrillingInterval, SizeBottomHoleZone, LockingPressure,
                LockingValueRotorSpeed, LockingValueLoad, LockingSpeedTalblok, TechnologicalRegimDrilling, TechnologicalRegimStudy,
                TechnologicalRegimeWeightHook);

            p207.Calculate(p205);
            p208.Calculate(p205, p206, curTime);

            p209.Calculate(p205, p206, curTime);
            p210.Calculate(p103, p206);

            p211.Calculate(p205, p204);
            p212.Calculate(p4, curTime, LockingPressure);

            p213.Calculate(p206, curTime);
        }
    }
}