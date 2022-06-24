
import { Controller } from 'stimulus'
import $ from 'jquery'

export default class extends Controller {
  static targets = [
    "index",
    "menu",
    "formEncode",
    "formDecode",
    "changePageEncode",
    "changePageDecode",
    "buttonEncodeSubmit",
    "buttonDecodeSubmit",
  ]

  static values = {
    encodeUrl: String,
  }

  initialize() {
    this.maker = ''
    this.page = 'encode'
  }

  encodeUrl(event) {
    let originalUrl = $("#encode_url").val()
    event.preventDefault()
    return $.ajax({
      method: 'POST',
      url: '/api/v1/short_urls/encode_shorted_url',
      dataType: "json",
      data: {
        authenticity_token: $('[name="csrf-token"]')[0].content,
        short_url: {
          original_url: originalUrl,
        }
      },
      success: function(response) {
        if(response?.error) {
          $("#error_encode_url").text("Error: " + response.error.message)
          $("#resutl_encode_url").text("")
        }else if(response?.duplicate) {
          $("#resutl_encode_url").text("Long URL: " + response.shorted_url)
          $("#error_encode_url").text("Error: " + response.duplicate.message)
        }
        else {
          $("#resutl_encode_url").text("Long URL: " + response.shorted_url)
          $("#error_encode_url").text("")
        }
      },
      error: function (response) {
        if(response.status === 429) {
          $("#error_encode_url").text("Error: " + response.responseJSON.error.message)
        } else {
          $("#error_encode_url").text("Error: " + response)
        }
        $("#resutl_encode_url").text("")
      }
    })
  }

  decodeUrl(event) {
    let shortedURL = $("#decode_url").val()
    event.preventDefault()
    return $.ajax({
      method: 'POST',
      url: '/api/v1/short_urls/decode_shorted_url',
      dataType: "json",
      data: {
        authenticity_token: $('[name="csrf-token"]')[0].content,
        short_url: {
          shorted_url: shortedURL,
        }
      },
      success: function(response) {
        if(response?.error) {
          $("#error_decode_url").text("Error: " + response.error.message)
          $("#resutl_decode_url").text("")
        }
        else {
          $("#resutl_decode_url").text("Original URL: " + response.original_url)
          $("#error_decode_url").text("")
        }
      },
      error: function (response) {
        $("#error_decode_url").text("Error: " + response)
        $("#resutl_decode_url").text("")
      }
    })
  }
}
