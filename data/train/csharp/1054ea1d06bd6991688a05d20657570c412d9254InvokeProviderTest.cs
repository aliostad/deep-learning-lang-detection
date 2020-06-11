using System.Windows.Automation;
using System.Windows.Forms;
using FluentAssertions;
using NUnit.Framework;
using UIA.Extensions.AutomationProviders.Interfaces;

namespace UIA.Extensions.AutomationProviders
{
    [TestFixture]
    public class InvokeProviderTest
    {
        private InvokeControlStub _invokeControl;
        private InvokeProvider _invokeProvider;
        private Control _control;

        [SetUp]
        public void SetUp()
        {
            _control = new Control();
            _invokeControl = new InvokeControlStub(_control);
            _invokeProvider = new InvokeProvider(_invokeControl);
        }

        [Test]
        public void ItHasTheCorrectPattern()
        {
            _invokeProvider.GetPatternProvider(InvokePatternIdentifiers.Pattern.Id)
                .Should().BeSameAs(_invokeProvider);
        }

        [Test]
        public void ItCanBeInvoked()
        {
            _invokeProvider.Invoke();
            _invokeControl.WasInvoked.Should().BeTrue();
        }

        [Test]
        public void ItCanTakeAction()
        {
            var actualInvocation = string.Empty;
            new InvokeProvider(_control, () => actualInvocation = "Things went down").Invoke();
            
            actualInvocation.Should().Be("Things went down");
        }

        class InvokeControlStub : InvokeControl
        {
            public InvokeControlStub(Control control) : base(control)
            { }

            public override void Invoke()
            {
                WasInvoked = true;
            }

            public bool WasInvoked { get; private set; }
        }
    }
}
