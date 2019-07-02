class UserDecorator < Draper::Decorator
  delegate_all

 
  def status_tag
    h.content_tag(:span,user.status? ? "Active" : "Blocked", class: "label "+ (user.status? ? "label-success" : "label-danger"))
  end

  def block_btn
    if user.status
      h.link_to('<em class="fa fa-lock" aria-hidden="true"></em>'.html_safe,h.status_admin_user_url(user), class:"btn btn-sm btn-danger ",title: "Block", data: { confirm:  "Are you sure to block this user?" }).html_safe
    else
      h.link_to('<em class="fa fa-unlock" aria-hidden="true"></em>'.html_safe,h.status_admin_user_url(user), class:"btn btn-sm btn-success " ,title: "Unblock", data: { confirm: "Are you sure to unblock this user?" }).html_safe
    end
  end

  def normal_user 
    if user.user_type
      h.link_to('<em class="fa fa-lock" aria-hidden="true"></em>'.html_safe,h.type_user_admin_user_path(user),method: :patch, class:"btn btn-sm btn-danger",title: "Simple Users", data: { confirm:  "Are you sure Change this user status to Normal User" }).html_safe
    else
      h.link_to('<em class="fa fa-unlock" aria-hidden="true"></em>'.html_safe,h.type_user_admin_user_path(user),method: :patch, class:"btn btn-sm btn-success " ,title: "Normal Users", data: { confirm: "Are you sure to unblock this user?" }).html_safe
    end
  end
  
end
