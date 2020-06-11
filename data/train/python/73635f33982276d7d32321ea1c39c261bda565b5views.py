from django.shortcuts import render

# Create your views here.


def single_view(request):
    u""" View for representing single timezone information """
    return render(request, 'single.html')


def manage_form(request):
    u""" View to manage TimeZones using ordinary add form """
    if request.method == 'POST':
        pass
    else:
        return render


def manage_formset(request):
    u""" View to manage TimeZone using formsets """
    if request.method == 'POST':
        pass
    else:
        return render
