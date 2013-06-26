require 'spec_helper'

describe 'Admin' do
  context "on admin homepage" do

    before :each do
      @post = Post.create(title: "Test Post", content: "A new post here")
      authenticate
    end

    it "can see a list of recent posts" do
      visit admin_posts_url
      page.should have_content "Test Post"
    end

    it "can edit a post by clicking the edit link next to a post" do
      visit admin_posts_url
      click_link "Edit"

      
      fill_in 'post_title', with: "Changed Title"
      click_button "Save"
      @post.reload.title.should eq("Changed Title")
    end

    it "can delete a post by clicking the delete link next to a post" do
      visit admin_posts_url
      expect {click_link "Delete"}.to change(Post, :count).by(-1)
    end


    it "can create a new post and view it" do
       visit new_admin_post_url

       expect {
         fill_in 'post_title',   with: "Hello world!"
         fill_in 'post_content', with: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat."
         page.check('post_is_published')
         click_button "Save"
       }.to change(Post, :count).by(1)

       page.should have_content "Published: true"
       page.should have_content "Post was successfully saved."
     end
  end

  context "editing post" do

    it "can mark an existing post as unpublished" do
      post = Post.create(title: "Published Post", content: "This one is published", is_published: true)
      authenticate
      visit admin_posts_url 
      click_link "Edit"
      uncheck(:post_is_published)
      click_button "Save"
      post.reload.is_published.should be_false
    end
  end

  context "on post show page" do

    before :each do
      @post = Post.create(title: "Published Post", content: "This one is published")
      authenticate
    end
    
    it "can visit a post show page by clicking the title" do
      visit admin_posts_url
      click_link "Published Post"
    end

    it "can see an edit link that takes you to the edit post path" do
      visit admin_post_url(@post)
      click_link "Edit"
    end

    it "can go to the admin homepage by clicking the Admin welcome page link" do
      visit admin_post_url(@post)
      click_link "Admin welcome page"
    end
  end
end
 
