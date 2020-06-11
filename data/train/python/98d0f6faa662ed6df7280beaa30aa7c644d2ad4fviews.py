from datetime import date, datetime
from django.http import HttpResponseRedirect, HttpResponse
from django.views.generic.base import TemplateView
from emencia.django.newsletter.models import Contact, MailingList

import csv

class EmenciaMailingListExporterView(TemplateView):
    
    @classmethod
    def as_csv(cls, request, **kwargs):
        mailing_list = MailingList.objects.get(pk=kwargs['mailing_list_id'])
        
        response = HttpResponse(mimetype='text/csv')
        response['Content-Disposition'] = 'attachment; filename=%sEmailList%s.csv' % (mailing_list.name, date.today().strftime('%Y%m%d'))
        
        subscribers = mailing_list.subscribers
        
        writer = csv.writer(response)
        
        emails = []
        
        for subscriber in subscribers.all():
            emails.append(subscriber.email)
        
        writer.writerow(emails)
        
        ''' writer.writerow(['Broker',
                         '30 Days (' + data['date_plus_30'].strftime('%Y-%m-%d') + ')',
                         '60 Days (' + data['date_plus_60'].strftime('%Y-%m-%d') + ')',
                         '90 Days (' + data['date_plus_90'].strftime('%Y-%m-%d') + ')'])
        
        for broker_stats in data['brokers']:
            writer.writerow([broker_stats['broker'],
                             CURRENCY_FORMAT.format(broker_stats['projection_30_days']),
                             CURRENCY_FORMAT.format(broker_stats['projection_60_days']),
                             CURRENCY_FORMAT.format(broker_stats['projection_90_days'])])
        
        writer.writerow(['Totals',
                         CURRENCY_FORMAT.format(data['broker_totals']['total_30_days']),
                         CURRENCY_FORMAT.format(data['broker_totals']['total_60_days']),
                         CURRENCY_FORMAT.format(data['broker_totals']['total_90_days'])]) '''
        
        return response