//using System.Threading.Tasks;
//using Caliburn.Micro;
//using Microsoft.Practices.Unity;
//using Prover.CommProtocol.MiHoneywell;
//using Prover.Core.Communication;
//using Prover.Core.DriveTypes;
//using Prover.Core.Models.Instruments;

//namespace Prover.Core.VerificationTests.Mechanical
//{
//    public sealed class MechanicalQaRunTestManager : QaRunTestManager
//    {
//        public MechanicalQaRunTestManager(IContainer container, Instrument instrument,
//            InstrumentCommunicator instrumentComm, BaseVolumeVerificationManager volumeTestManager)
//            : base(container, instrument, instrumentComm)
//        {
//            VolumeTestManagerBase = volumeTestManager;
//        }

//        public static async Task<MechanicalQaRunTestManager> Create(IContainer container, InstrumentType instrumentType,
//            ICommPort instrumentPort, string tachometerPortName)
//        {
//            var instrumentComm = new InstrumentCommunicator(container.Resolve<IEventAggregator>(), instrumentPort,
//                instrumentType);

//            TachometerCommunicator tachComm = null;
//            if (!string.IsNullOrEmpty(tachometerPortName))
//                tachComm = new TachometerCommunicator(tachometerPortName);

//            await commClient.Connect();
//            var itemValues = await commClient.GetItemValues(commClient.ItemDetails.GetAllItemNumbers());
//            await commClient.Disconnect();


//            var instrument = new Instrument(InstrumentType.MiniAT, itemValues);
//            var driveType = new MechanicalDrive(instrument);
//            CreateVerificationTests(instrument, driveType);

//            var volumeTest = instrument.VolumeTest;
//            var volumeManager = new RotaryVolumeVerification(container.Resolve<IEventAggregator>(), volumeTest,
//                instrumentComm, tachComm);

//            var manager = new MechanicalQaRunTestManager(container, instrument, commClient, volumeManager, null);
//            await manager.SaveAsync();
//            container.RegisterInstance<QATestRunManager>(manager);

//            return manager;
//        }
//    }
//}

