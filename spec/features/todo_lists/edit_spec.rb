require 'spec_helper'

describe "Editing todo lists" do

	let!(:todo_list) { TodoList.create(title: "Groceries", description: "My grocery list") }

	def update_todo_list(options = {})
		options[:new_title] ||= "New title"
		options[:new_description] ||= "New description"

		todo_list = options[:todo_list]

		visit "/todo_lists"
		within "#todo_list_#{todo_list.id}" do
			click_link "Edit"
		end

		fill_in "Title", with: options[:new_title]
		fill_in "Description", with: options[:new_description]
		click_button "Update Todo list"
	end


	it "updates a todo list successfully with correct information" do
		update_todo_list(todo_list: todo_list)

		todo_list.reload	# refreshes the memory from the database

		expect(page).to have_content("Todo list was successfully updated")
		expect(todo_list.title).to eq("New title")
		expect(todo_list.description).to eq("New description")
	end

	it "displays an error when the todo list is updated with no title" do
		title = todo_list.title
		update_todo_list(todo_list: todo_list,
										 new_title: "")
		todo_list.reload
		expect(todo_list.title).to eq(title)
		expect(page).to have_content("error")
	end

	it "displays an error when the todo list is updated with a title of less than 3 characters" do
		title = todo_list.title
		update_todo_list(todo_list: todo_list,
										 new_title: "Hi")
		todo_list.reload
		expect(todo_list.title).to eq(title)
		expect(page).to have_content("error")
	end

	it "displays an error when the todo list is updated with no description" do
		description = todo_list.description
		update_todo_list(todo_list: todo_list,
										 new_description: "")
		todo_list.reload
		expect(todo_list.description).to eq(description)
		expect(page).to have_content("error")
	end

	it "displays an error when the todo list is updated with a description of less than 5 characters" do
		description = todo_list.description
		update_todo_list(todo_list: todo_list,
									 new_description: "Food")
		todo_list.reload
		expect(todo_list.description).to eq(description)
		expect(page).to have_content("error")
	end
end