# -*- coding: utf-8 -*-
module ChunksHelper
  def link_to_download_chunk(chunk)
    if chunk.status.completed?
      link_to 'Télécharger', source_chunk_path(chunk.source, chunk, :format => chunk.file_extension), :class => "download"
    else
      link_to 'En préparation', source_chunk_path(chunk.source, chunk), :class => "download-pending chunk", :title => "Vérifier l'état"
    end
  end

  def format_radio_button(form, format_presenter)
    data_attributes = {
      :"data-requires-bitrate" => format_presenter.requires_birate?,
      :"data-requires-quality" => format_presenter.requires_quality?
    }
    form.radio_button :format, format_presenter.format, data_attributes
  end

  def format_radio_buttons(form)
    content_tag(:ul) do
      ChunkFormatPresenter.all.collect do |format_presenter|
        content_tag(:li) do
          [ format_radio_button(form, format_presenter),
            form.label("format_#{format_presenter.format}", format_presenter.name),
            link_to(image_tag('ui/help.png', :alt => '?'), format_presenter.wikipedia_url) ].join(" ")
        end
      end.join("\n")
    end
  end

end
