using System;
using Distributr.Core.CommandHandler.DocumentCommandHandlers.DispatchNotes;
using Distributr.Core.Commands.DocumentCommands.DispatchNotes;
using Distributr.Core.Data.EF;
using log4net;

namespace Distributr.Core.Data.CommandHandlers.DocumentCommandHandlers.DispatchNotes
{
    public class ConfirmDispatchNoteCommandHandler : BaseCommandHandler, IConfirmDispatchNoteCommandHandler
    {
       
        ILog _log = LogManager.GetLogger("ConfirmDispatchNoteCommandHandler");
        private CokeDataContext _cokeDataContext;

        public ConfirmDispatchNoteCommandHandler(CokeDataContext cokeDataContext) : base(cokeDataContext)
        {
            _cokeDataContext = cokeDataContext;
        }

        public void Execute(ConfirmDispatchNoteCommand command)
        {
            _log.InfoFormat("Execute {1} - Command Id {0} ", command.CommandId, command.GetType().ToString());
            try
            {
                if (!DocumentExists(command.DocumentId))
                {
                    _log.InfoFormat("Failed to  Execute {1} - Command Id {0} ", command.CommandId, command.GetType().ToString());
                    return;
                }
                ConfirmDocument(command.DocumentId);
                //DispatchNote dispatchNote = _documentRepository.GetById(command.DocumentId) as DispatchNote;
                //if (dispatchNote.DispatchType == DispatchNoteType.Delivery)
                //{
                //    foreach (var lineItem in dispatchNote.LineItems)
                //    {
                //        //on the server debit issuer cc
                //        _inventoryWorkflow.InventoryAdjust(dispatchNote.DocumentIssuerCostCentre.Id, lineItem.Product.Id,
                //                                           -lineItem.Qty, DocumentType.DispatchNote, dispatchNote.Id,
                //                                           dispatchNote.DocumentDateIssued,InventoryAdjustmentNoteType.Available);
                //        //credit recipient cc
                //        _inventoryWorkflow.InventoryAdjust(dispatchNote.DocumentRecipientCostCentre.Id,
                //                                           lineItem.Product.Id,
                //                                           lineItem.Qty, DocumentType.DispatchNote, dispatchNote.Id,
                //                                           dispatchNote.DocumentDateIssued, InventoryAdjustmentNoteType.Available);
                //    }
                //}
            }
            catch (Exception ex)
            {
                _log.ErrorFormat("Error Execute {1} - Command Id {0} ", command.CommandId, command.GetType());
                _log.Error("ConfirmDispatchNoteCommandHandler exception", ex);
                throw ;
            }
        }

    }
}
