require 'helper'
require 'fixtures/markup_app/app'

class TestFormHelpers < Test::Unit::TestCase
  include SinatraMore::FormHelpers

  def app
    MarkupDemo.tap { |app| app.set :environment, :test }
  end

  context 'for #form_tag method' do
    should "display correct forms in ruby" do
      actual_html = form_tag('/register', :class => 'test', :action => "hello") { "Demo" }
      assert_has_tag(:form, :class => "test") { actual_html }
    end
    
    should "display correct inputs in ruby for form_tag" do
      actual_html = form_tag('/register', :class => 'test', :action => "hello") { text_field_tag(:username) }
      assert_has_tag('form input', :type => 'text', :name => "username") { actual_html }
    end

    should "display correct forms in erb" do
      visit '/erb/form_tag'
      assert_have_selector 'form.simple-form', :action => '/simple'
      assert_have_selector 'form.advanced-form', :action => '/advanced', :id => 'advanced', :method => 'get'
    end

    should "display correct forms in haml" do
      visit '/haml/form_tag'
      assert_have_selector 'form.simple-form', :action => '/simple'
      assert_have_selector 'form.advanced-form', :action => '/advanced', :id => 'advanced', :method => 'get'
    end
  end

  context 'for #field_set_tag method' do
    should "display correct field_sets in ruby" do
      actual_html = field_set_tag("Basic", :class => 'basic') { "Demo" }
      assert_has_tag(:fieldset, :class => 'basic') { actual_html }
      assert_has_tag('fieldset legend', :content => "Basic") { actual_html }
    end

    should "display correct field_sets in erb" do
      visit '/erb/form_tag'
      assert_have_selector 'form.simple-form fieldset', :count => 1
      assert_have_no_selector 'form.simple-form fieldset legend'
      assert_have_selector 'form.advanced-form fieldset', :count => 1, :class => 'advanced-field-set'
      assert_have_selector 'form.advanced-form fieldset legend', :content => "Advanced"
    end

    should "display correct field_sets in haml" do
      visit '/haml/form_tag'
      assert_have_selector 'form.simple-form fieldset', :count => 1
      assert_have_no_selector 'form.simple-form fieldset legend'
      assert_have_selector 'form.advanced-form fieldset', :count => 1, :class => 'advanced-field-set'
      assert_have_selector 'form.advanced-form fieldset legend', :content => "Advanced"
    end
  end

  context 'for #error_messages_for method' do
    should "display correct error messages list in ruby" do
      user = stub(:class => "User", :errors => stub(:full_messages => ["1", "2"], :none? => false), :blank? => false)
      actual_html = error_messages_for(user)
      assert_has_tag('div.field-errors') { actual_html }
      assert_has_tag('div.field-errors p', :content => "The user could not be saved") { actual_html }
      assert_has_tag('div.field-errors ul.errors-list') { actual_html }
      assert_has_tag('div.field-errors ul.errors-list li', :count => 2) { actual_html }
    end

    should "display correct error messages list in erb" do
      visit '/erb/form_tag'
      assert_have_no_selector 'form.simple-form .field-errors'
      assert_have_selector 'form.advanced-form .field-errors'
      assert_have_selector 'form.advanced-form .field-errors p', :content => "There are problems with saving user!"
      assert_have_selector 'form.advanced-form .field-errors ul.errors-list'
      assert_have_selector 'form.advanced-form .field-errors ul.errors-list li', :count => 3
      assert_have_selector 'form.advanced-form .field-errors ul.errors-list li', :content => "This is a second fake error"
    end

    should "display correct error messages list in haml" do
      visit '/haml/form_tag'
      assert_have_no_selector 'form.simple-form .field-errors'
      assert_have_selector 'form.advanced-form .field-errors'
      assert_have_selector 'form.advanced-form .field-errors p', :content => "There are problems with saving user!"
      assert_have_selector 'form.advanced-form .field-errors ul.errors-list'
      assert_have_selector 'form.advanced-form .field-errors ul.errors-list li', :count => 3
      assert_have_selector 'form.advanced-form .field-errors ul.errors-list li', :content => "This is a second fake error"
    end
  end

  context 'for #label_tag method' do
    should "display label tag in ruby" do
      actual_html = label_tag(:username, :class => 'long-label', :caption => "Nickname")
      assert_has_tag(:label, :for => 'username', :class => 'long-label', :content => "Nickname: ") { actual_html }
    end

    should "display label tag in erb for simple form" do
      visit '/erb/form_tag'
      assert_have_selector 'form.simple-form label', :count => 2
      assert_have_selector 'form.simple-form label', :content => "Username", :for => 'username'
      assert_have_selector 'form.simple-form label', :content => "Password", :for => 'password'
    end
    should "display label tag in erb for advanced form" do
      visit '/erb/form_tag'
      assert_have_selector 'form.advanced-form label', :count => 4
      assert_have_selector 'form.advanced-form label.first', :content => "Nickname", :for => 'username'
      assert_have_selector 'form.advanced-form label.first', :content => "Password", :for => 'password'
      assert_have_selector 'form.advanced-form label.about', :content => "About Me", :for => 'about'
      assert_have_selector 'form.advanced-form label.photo', :content => "Photo"   , :for => 'photo'
    end

    should "display label tag in haml for simple form" do
      visit '/haml/form_tag'
      assert_have_selector 'form.simple-form label', :count => 2
      assert_have_selector 'form.simple-form label', :content => "Username", :for => 'username'
      assert_have_selector 'form.simple-form label', :content => "Password", :for => 'password'
    end
    should "display label tag in haml for advanced form" do
      visit '/haml/form_tag'
      assert_have_selector 'form.advanced-form label', :count => 4
      assert_have_selector 'form.advanced-form label.first', :content => "Nickname", :for => 'username'
      assert_have_selector 'form.advanced-form label.first', :content => "Password", :for => 'password'
      assert_have_selector 'form.advanced-form label.about', :content => "About Me", :for => 'about'
      assert_have_selector 'form.advanced-form label.photo', :content => "Photo"   , :for => 'photo'
    end
  end

  context 'for #text_field_tag method' do
    should "display text field in ruby" do
      actual_html = text_field_tag(:username, :class => 'long')
      assert_has_tag(:input, :type => 'text', :class => "long", :name => 'username') { actual_html }
    end

    should "display text field in erb" do
      visit '/erb/form_tag'
      assert_have_selector 'form.simple-form input[type=text]', :count => 1, :name => 'username'
      assert_have_selector 'form.advanced-form fieldset input[type=text]', :count => 1, :name => 'username', :id => 'the_username'
    end

    should "display text field in haml" do
      visit '/haml/form_tag'
      assert_have_selector 'form.simple-form input[type=text]', :count => 1, :name => 'username'
      assert_have_selector 'form.advanced-form fieldset input[type=text]', :count => 1, :name => 'username', :id => 'the_username'
    end
  end

  context 'for #text_area_tag method' do
    should "display text area in ruby" do
      actual_html = text_area_tag(:about, :class => 'long')
      assert_has_tag(:textarea, :class => "long", :name => 'about') { actual_html }
    end

    should "display text area in erb" do
      visit '/erb/form_tag'
      assert_have_selector 'form.advanced-form textarea', :count => 1, :name => 'about', :class => 'large'
    end

    should "display text area in haml" do
      visit '/haml/form_tag'
      assert_have_selector 'form.advanced-form textarea', :count => 1, :name => 'about', :class => 'large'
    end
  end

  context 'for #password_field_tag method' do
    should "display password field in ruby" do
      actual_html = password_field_tag(:password, :class => 'long')
      assert_has_tag(:input, :type => 'password', :class => "long", :name => 'password') { actual_html }
    end

    should "display password field in erb" do
      visit '/erb/form_tag'
      assert_have_selector 'form.simple-form input[type=password]', :count => 1, :name => 'password'
      assert_have_selector 'form.advanced-form input[type=password]', :count => 1, :name => 'password'
    end

    should "display password field in haml" do
      visit '/haml/form_tag'
      assert_have_selector 'form.simple-form input[type=password]', :count => 1, :name => 'password'
      assert_have_selector 'form.advanced-form input[type=password]', :count => 1, :name => 'password'
    end
  end

  context 'for #file_field_tag method' do
    should "display file field in ruby" do
      actual_html = file_field_tag(:photo, :class => 'photo')
      assert_has_tag(:input, :type => 'file', :class => "photo", :name => 'photo') { actual_html }
    end

    should "display file field in erb" do
      visit '/erb/form_tag'
      assert_have_selector 'form.advanced-form input[type=file]', :count => 1, :name => 'photo', :class => 'upload'
    end

    should "display file field in haml" do
      visit '/haml/form_tag'
      assert_have_selector 'form.advanced-form input[type=file]', :count => 1, :name => 'photo', :class => 'upload'
    end
  end

  context 'for #submit_tag method' do
    should "display submit tag in ruby" do
      actual_html = submit_tag("Update", :class => 'success')
      assert_has_tag(:input, :type => 'submit', :class => "success", :value => 'Update') { actual_html }
    end

    should "display submit tag in erb" do
      visit '/erb/form_tag'
      assert_have_selector 'form.simple-form input[type=submit]', :count => 1, :value => "Submit"
      assert_have_selector 'form.advanced-form input[type=submit]', :count => 1, :value => "Login"
    end

    should "display submit tag in haml" do
      visit '/haml/form_tag'
      assert_have_selector 'form.simple-form input[type=submit]', :count => 1, :value => "Submit"
      assert_have_selector 'form.advanced-form input[type=submit]', :count => 1, :value => "Login"
    end
  end
end