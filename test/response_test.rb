require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require './lib/response'
require './lib/game.rb'
# require './lib/ruby_server.rb'

class ResponseTest < Minitest::Test

  def test_if_game_has_started_a_second_post_request_gives_a_403_code
    request = Faraday.new
    response = request.post 'http://127.0.0.1:9292/start_game'
    response = request.post 'http://127.0.0.1:9292/start_game'
    assert_equal '403 Forbidden', response.body[25...38]
  end

  def test_that_if_requested_an_unknow_path_HTTP_responds_with_404_code
    request = Faraday.new
    response = request.get 'http://127.0.0.1:9292/fofamalou'
    assert_equal '404 Not Found', response.body[25...38]
    response = request.get 'http://127.0.0.1:9292/xxxx'
    assert_equal '404 Not Found', response.body[25...38]
  end

  def test_that_post_requests_made_on_paths_available_for_get_only_respond_with_unauthorized_code
    request = Faraday.new
    response = request.post 'http://127.0.0.1:9292/hello'
    assert_equal '401 Unauthorized', response.body[25...41]
    response = request.post 'http://127.0.0.1:9292/datetime'
    assert_equal '401 Unauthorized', response.body[25...41]
  end

  def test_taht_if_path_is_not_exactly_right_it_responds_with_not_found_error
    request = Faraday.new
    response = request.post 'http://127.0.0.1:9292/hello/'
    assert_equal '404 Not Found', response.body[25...38]
    response = request.post 'http://127.0.0.1:9292/datetime_'
    assert_equal '404 Not Found', response.body[25...38]
  end

  def test_that_word_search_path_works_for_get_requests_only
    request = Faraday.new
    response = request.post 'http://127.0.0.1:9292/word_search'
    assert_equal '401 Unauthorized', response.body[25...41]
    response = request.get 'http://127.0.0.1:9292/word_search?word=apple'
    assert_equal 'APPLE is a known word', response.body[25...46]
  end

  def test_that_requests_to_force_error_path_respond_with_internal_error
    request = Faraday.new
    response = request.get 'http://127.0.0.1:9292/force_error'
    assert_equal '500 Internal Server Error', response.body[25...50]
    response = request.post 'http://127.0.0.1:9292/force_error'
    assert_equal '500 Internal Server Error', response.body[25...50]
  end

  def test_HTTP_response_for_game_is_unique_if_game_not_started
    skip
    response = Faraday.get 'http://127.0.0.1:9292/game'
    message = "You haven't started a game yet. POST to /start_game first."
    assert_equal message, response.body[25...83]
  end

end
