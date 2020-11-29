module Ulysses
  # Nanoc filter for replacing the Ulysses-generated filename to images with
  # actual output filenames as generated by Nanoc.
  class EmbeddedImagesFilter < Nanoc::Filter
    identifier :ulysses_embedded_images

    def run(content, _params = {})
      return content unless @item[:inline_file_items]&.any?

      @item[:inline_file_items].inject(content) do |acc, inline_file_item|
        actual_item = @items.find do |item|
          item.attributes[:id] == inline_file_item.attributes[:id]
        end
        acc.gsub(/(?<=src=")(#{actual_item.attributes[:explicit_filename]}|#{actual_item.attributes[:id]})(?=")/, actual_item.path)
      end
    end
  end
end
