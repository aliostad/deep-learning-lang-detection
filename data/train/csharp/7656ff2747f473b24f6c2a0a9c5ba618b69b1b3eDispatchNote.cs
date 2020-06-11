namespace LiteDispatch.Domain.Entities
{
  using System;
  using System.Collections.Generic;
  using System.Data.Entity.ModelConfiguration;
  using Core.DTOs;
  using Models;
  using Repository;

  public class DispatchNote
    :EntityBase
  {
    public const string New = "New";
    public const string InTransit = "InTransit";
    public const string Received = "Received";

    protected DispatchNote()
    {
      DispatchLineSet = new HashSet<DispatchLine>();
    }

    public static DispatchNote Create(IRepositoryLocator locator, DispatchNoteModel model)
    {
      var haulier = locator.GetById<Haulier>(model.HaulierId);
      var instance = new DispatchNote
        {
          CreationDate = model.CreationDate,
          LastUpdate = model.CreationDate,
          DispatchDate = model.DispatchDate,
          DispatchNoteStatus = New,
          DispatchReference = model.DispatchReference,
          Haulier = haulier,
          TruckReg = model.TruckReg,
          User = model.User
        };

      locator.Save(instance);
      model.Lines.ForEach(l => instance.AddLine(locator, l));
      return instance;
    }

    public DispatchLine AddLine(IRepositoryLocator locator, DispatchLineModel dispatchLineModel)
    {
      var line = DispatchLine.Create(locator, dispatchLineModel);
      DispatchLineSet.Add(line);
      return line;
    }

    #region Persisted Properties

    public virtual Haulier Haulier { get; private set; }
    public DateTime DispatchDate { get; private set; }
    public string DispatchNoteStatus { get; private set; }
    public string TruckReg { get; private set; }
    public string DispatchReference { get; private set; }
    public DateTime CreationDate { get; private set; }
    public DateTime LastUpdate { get; private set; }
    public string User { get; private set; }
    public virtual TrackingNotification LastTrackingNotification { get; private set; }
    protected virtual ICollection<DispatchLine> DispatchLineSet { get; set; }

    #endregion
    #region Public Methods

    public IEnumerable<DispatchLine> DispatchLines()
    {
      return DispatchLineSet;
    }

    #endregion

    public class Mapping : EntityTypeConfiguration<DispatchNote>
    {
      public Mapping()
      {
        HasMany(d => d.DispatchLineSet);
        HasOptional(d => d.LastTrackingNotification).WithMany();
      }
    }

    public TrackingResponseDto CreateTrackingNotification(IRepositoryLocator locator, TrackingNotificationDto dto, TrackingResponseDto response)
    {
      if (!(DispatchNoteStatus == New |
            DispatchNoteStatus == InTransit))
      {

        response.Error = "DispatchNote was found but its status was not new or in-transit, it was: " + DispatchNoteStatus;
        return response;
      }

      if (DispatchNoteStatus == New)
      {
        DispatchNoteStatus = InTransit;
      }

      LastUpdate = DateTime.Now;
      var trackingNotification = TrackingNotification.Create(locator, dto, this);
      LastTrackingNotification = trackingNotification;
      response.Accepted = true;
      return response;
    }    

    public string LastTrackingNotificationDescription()
    {
      var distance = LastTrackingNotification == null
                       ? "N/A"
                       : string.Format("{0} {1}", LastTrackingNotification.Distance.ToString("N0"),
                                       LastTrackingNotification.DistanceDescription());

      var duration = LastTrackingNotification == null
                       ? "N/A"
                       : GetDurationFromSeconds(LastTrackingNotification.Duration);

      return string.Format("{0} - ETA in: {1}", distance, duration);
    }

    private static string GetDurationFromSeconds(double duration)
    {
      var span = new TimeSpan(0, 0, (int)duration);

      var minutes = span.ToString("mm");
      var hrs = span.ToString("hh");
      return string.Format("{0} hrs {1} mins", hrs, minutes);
    }
  }
}