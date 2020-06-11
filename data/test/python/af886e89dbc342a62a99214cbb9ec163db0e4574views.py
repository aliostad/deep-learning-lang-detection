from django.shortcuts import render, render_to_response, RequestContext
from django.http import HttpResponseRedirect
from gowan.forms import PieceForm, GlazeLookupForm, DocumentationForm,\
ConditionChoiceForm, ExhibitionForm, HeathLineLookupForm, LogoForm,MakerLookupForm,\
MaterialLookupForm, MethodLookupForm, PublicationForm, SetCollectionForm


def home(request):

    form = PieceForm(request.POST or None)

    if form.is_valid():
        save_it = form.save(commit=False)
        save_it.save()

    return render_to_response("kk.html",
                              locals(),
                              context_instance=RequestContext(request))


def GlazeView(request):

    form = GlazeLookupForm(request.POST or None)

    if form.is_valid():
        save_it = form.save(commit=False)
        save_it.save()

    return render_to_response("kk.html",
                              locals(),
                              context_instance=RequestContext(request))


def DimensionView(request):
    form = DimensionForm(request.POST or None)

    if form.is_valid():
        save_it = form.save(commit=False)
        save_it.save()

    return render_to_response("kk.html",
                              locals(),
                              context_instance=RequestContext(request))


def DocumentationView(request):

    form = DocumentationForm(request.POST or None)

    if form.is_valid():
        save_it = form.save(commit=False)
        save_it.save()

    return render_to_response("kk.html",
                              locals(),
                              context_instance=RequestContext(request))


def ConditionChoiceView(request):

    form = ConditionChoiceForm(request.POST or None)

    if form.is_valid():
        save_it = form.save(commit=False)
        save_it.save()

    return render_to_response("kk.html",
                              locals(),
                              context_instance=RequestContext(request))


def ExhibitionView(request):

    form = ExhibitionForm(request.POST or None)

    if form.is_valid():
        save_it = form.save(commit=False)
        save_it.save()

    return render_to_response("kk.html",
                              locals(),
                              context_instance=RequestContext(request))


def HeathLineLookupView(request):

    form = HeathLineLookupForm(request.POST or None)

    if form.is_valid():
        save_it = form.save(commit=False)
        save_it.save()

    return render_to_response("kk.html",
                              locals(),
                              context_instance=RequestContext(request))


def LogoView(request):

    form = LogoForm(request.POST or None)

    if form.is_valid():
        save_it = form.save(commit=False)
        save_it.save()

    return render_to_response("kk.html",
                              locals(),
                              context_instance=RequestContext(request))


def MakerLookupView(request):

    form = MakerLookupForm(request.POST or None)

    if form.is_valid():
        save_it = form.save(commit=False)
        save_it.save()

    return render_to_response("kk.html",
                              locals(),
                              context_instance=RequestContext(request))


def MaterialLookupView(request):

    form = MaterialLookupForm(request.POST or None)

    if form.is_valid():
        save_it = form.save(commit=False)
        save_it.save()

    return render_to_response("kk.html",
                              locals(),
                              context_instance=RequestContext(request))


def MethodLookupView(request):

    form = MethodLookupForm(request.POST or None)

    if form.is_valid():
        save_it = form.save(commit=False)
        save_it.save()

    return render_to_response("kk.html",
                              locals(),
                              context_instance=RequestContext(request))


def PublicationView(request):

    form = PublicationForm(request.POST or None)

    if form.is_valid():
        save_it = form.save(commit=False)
        save_it.save()

    return render_to_response("kk.html",
                              locals(),
                              context_instance=RequestContext(request))


def SetCollectionView(request):

    form = SetCollectionForm(request.POST or None)

    if form.is_valid():
        save_it = form.save(commit=False)
        save_it.save()

    return render_to_response("kk.html",
                              locals(),
                              context_instance=RequestContext(request))

from django.shortcuts import render, render_to_response, RequestContext
from django.http import HttpResponseRedirect
from django.core.urlresolvers import reverse
from  models import Exhibition, Piece
from  forms import UserSubmittedExhibitionForm, PieceFormSet


def Submit_exhibitView(request):
    if request.POST:

        form = UserSubmittedExhibitForm(request.POST)
        if form.is_valid():
            exhibition = form.save(commit=False)
            piece_formset = PieceFormSet(request.POST, instance=exhibit)
            if piece_formset.is_valid():
                exhibit.save()
                piece_formset.save()
                return HttpResponseRedirect(reverse('exhibitions_submit_posted'))
        else:
          form = UserSubmittedExibitionForm()
          piece_formset = PieceFormSet(instance=Exhibition())
    return render_to_response("exhibitions/submit.html", {
        "form": form,
        "piece_formset": piece_formset,
    }, context_instance=RequestContext(request))



