module ServicesHelper
  
  def get_full_track_name(track)
    if track.name.blank?
      return nil
    else
      if track.artist.blank? 
        if track.album.blank?
          track.name
        else # !track.album.blank?
          "#{track.name} (#{track.album})"
        end
      else #!track.artist.blank?

        if track.album.blank?
        "#{track.artist} - #{track.name}"
        else # !track.album.blank?
         "#{track.artist} - #{track.name} (#{track.album})"
        end
      end  
    end
#    track.artist + ' - ' + track.name + track.album
  end
end
