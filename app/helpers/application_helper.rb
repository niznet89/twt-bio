module ApplicationHelper
  def profile_photo(user)
    if user.photo.attached?
      cl_image_tag user.photo.key, :gravity=>"face", :height=>181, :crop=>"thumb", class: "avatar-large"
    else
      image_tag "https://res.cloudinary.com/dmty5wfjh/image/upload/v1653601128/astronaut_tykby8.jpg", class: "avatar-large"
    end
  end
end
