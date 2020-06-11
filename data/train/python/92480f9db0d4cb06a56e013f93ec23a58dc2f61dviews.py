from flask import render_template
from . import api_search
from .forms import ApiSearchForm
from ..tools.api_tools import ApiGetter

@api_search.route('/api_search', methods=['GET', 'POST'])
def index():
    form = ApiSearchForm()
    qa = ApiGetter()
    if form.validate_on_submit():
        api_response = qa.get_twitch(form.search_bar.data)
        streams = api_response['streams']
        return render_template('api_search/api_search.html',
                               form=form,
                               search_results=streams)
    return render_template('api_search/api_search.html', form=form)
