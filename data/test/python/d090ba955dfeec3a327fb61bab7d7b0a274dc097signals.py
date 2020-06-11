from django.db.models.signals import post_save
from csvapp.models import Document, SortedDocument
from csvapp.tasks import clean_and_update_document, create_sorted_document_file


def post_save_document(sender, instance, created, **kwargs):
    if created:
        clean_and_update_document.delay(instance.id)


def post_save_sorted_document(sender, instance, created, **kwargs):
    if created:
        create_sorted_document_file.delay(instance.id)


post_save.connect(
    post_save_document,
    sender=Document)


post_save.connect(
    post_save_sorted_document,
    sender=SortedDocument)
