# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)# each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
 rex =  /#{e1}.*#{e2}/m
 page.body.index(rex).should_not == nil

  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  #flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"
When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rlist = rating_list.split(%r{,\s*})
  ["G","PG","PG-13","R","NC-17"].each do |rating|
    if uncheck != "un"
      if rlist.include?(rating)
        check("ratings_"+rating)
      else
        uncheck("ratings_"+rating)
      end
    else
      if rlist.include?(rating)
        uncheck("ratings_"+rating)
      else
        check("ratings_"+rating)
      end
    end
  end
end


Then /I should see all the movies/ do
  totalrows = diplayedrows = 0
  Movie.all.each do
    totalrows = totalrows + 1
  end
  displayedrows = page.all('table#movies tr').count - 1 #subtract the header
  displayedrows.should == totalrows
end



Then /^the table should be sorted by (.*)$/ do |criteria|
  count = 0
  criteria.gsub!(" ","_")
  e1 = e2 = ""
  page.all('table#movies tr').each do |row|
    if count >=1 
      e2 = row[criteria]
    else
      e1 = e2
      e2 = row[criteria]
      step "I should see \"#{e1}\" before \"#{e2}\""
    count = count + 1
    end
  end
  1.should == 1
end

Then /^the director of "(.*?)" should be "(.*?)"$/ do |name, rector|
  Movie.find_by_title(name).director.should == rector
end


