function youtube(args)
    local videoid = pandoc.utils.stringify(args[1])

    -- Assemble HTML to be returned
    local html = '<div id="youtube-frame" style="position: relative; padding-bottom: 56.25%; /* 16:9 */ height: 0; margin-bottom: 1rem;"><iframe width="100%" height="" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;" src="https://www.youtube.com/embed/'
        .. videoid
        .. '" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>'

    if quarto.doc.isFormat('html') then
	    return pandoc.RawInline('html', html)
    else
        return pandoc.Null()
    end
end
