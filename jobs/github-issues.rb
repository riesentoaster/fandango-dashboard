#!/usr/bin/env ruby
require 'octokit'
require 'date'

client = Octokit::Client.new

SCHEDULER.every '10m', :first_in => 0 do |job|
  issues = client.issues('fandango-fuzzer/fandango', state: 'open', sort: 'updated', direction: 'desc', per_page: 100)
  
  # Calculate 24 hours ago
  twenty_four_hours_ago = Time.now - 24 * 60 * 60
  
  # Separate pull requests and issues
  pull_requests = issues.select { |item| item.pull_request }
  issues_only = issues.reject { |item| item.pull_request }
  
  # Helper method to create table rows
  def create_table_rows(items, twenty_four_hours_ago)
    items.map do |item|
      # Check if dates are within past 24 hours
      created_recent = item.created_at > twenty_four_hours_ago
      updated_recent = item.updated_at > twenty_four_hours_ago
      
      # Base style for date fields
      base_date_style = 'border-right: 1px solid black; padding: 0 5px; color: white'
      recent_date_style = base_date_style + '; background-color: #ffa500' # Orange background for better contrast with white text
      
      created_style = created_recent ? recent_date_style : base_date_style
      updated_style = updated_recent ? recent_date_style : base_date_style
      
      {
        cols: [
          { style: 'border-right: 1px solid black; padding: 0 5px; color: white', class: 'left', value: item.title },
          { style: 'border-right: 1px solid black; padding: 0 5px; color: white', value: item.user.login },
          { style: 'border-right: 1px solid black; padding: 0 5px; color: white', value: item.assignee ? item.assignee.login : '' },
          { style: 'border-right: 1px solid black; padding: 0 5px; color: white', value: item.comments },
          { style: created_style, value: item.created_at.strftime("%Y-%m-%d %H:%M") },
          { style: updated_style, value: item.updated_at.strftime("%Y-%m-%d %H:%M") }
        ]
      }
    end
  end
  
  # Create headers for both tables (without the "Kind" column since we're separating them)
  table_headers = [{ cols: [
    { style: 'padding: 0 5px; color: white', value: "Title" },
    { style: 'padding: 0 5px; color: white', value: "Creator" },
    { style: 'padding: 0 5px; color: white', value: "Assigned" },
    { style: 'padding: 0 5px; color: white', value: "Comments" },
    { style: 'padding: 0 5px; color: white', value: "Created" },
    { style: 'padding: 0 5px; color: white', value: "Updated" }
  ]}]

  
  # Create rows for both tables (limit to 20 items each)
  pr_rows = create_table_rows(pull_requests.first(20), twenty_four_hours_ago)
  issues_rows = create_table_rows(issues_only.first(20), twenty_four_hours_ago)
  
  # Send events for both tables
  send_event('fandango-pull-requests', { hrows: table_headers, rows: pr_rows })
  send_event('fandango-issues', { hrows: table_headers, rows: issues_rows })
end