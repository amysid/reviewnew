class UserDecorator < Draper::Decorator
  delegate_all

 
  def status_tag
    h.content_tag(:span,user.status? ? "Active" : "Blocked", class: "label "+ (user.status? ? "label-success" : "label-danger"))
  end
  def block_btn
    if user.status
      h.link_to('<em class="fa fa-lock" aria-hidden="true"></em>'.html_safe,h.status_admin_user_url(user),method: :post, class:"btn btn-sm btn-danger",title: "Block", data: { confirm:  "Are you sure to block this user?" }).html_safe
    else
      h.link_to('<em class="fa fa-unlock" aria-hidden="true"></em>'.html_safe,h.status_admin_user_url(user),method: :post, class:"btn btn-sm btn-success " ,title: "Unblock", data: { confirm: "Are you sure to unblock this user?" }).html_safe
    end
  end
end
