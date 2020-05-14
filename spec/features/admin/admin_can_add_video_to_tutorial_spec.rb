require 'rails_helper'

describe 'An admin user can add videos to tutorials' do
  before(:each) do
    @admin = create(:user, role: 1)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    @tutorial = create(:tutorial)
    @video1 = create(:video, tutorial_id: @tutorial.id)
    @expected = "{\n  \"kind\": \"youtube#videoListResponse\",\n  \"etag\": \"SOGskxZSwxbvO48dSuanvS-O4VA\",\n  \"items\": [\n    {\n      \"kind\": \"youtube#video\",\n      \"etag\": \"qiVXhoiid1xIG5Fz4IZwJ8Rghf0\",\n      \"id\": \"cit17Si-Vts\",\n      \"snippet\": {\n        \"publishedAt\": \"2016-02-20T16:03:54Z\",\n        \"channelId\": \"UCnmW9TwXxM3_lZRfGPDB-uA\",\n        \"title\": \"THE FIXX   Red Skies  1982    HQ\",\n        \"description\": \"\\\"Red Skies\\\" is a song by new wave rock group The Fixx. Released in 1982, it was the third single from the band's debut album, Shuttered Room. The song charted in the Netherlands, United Kingdom and United States, and was re-recorded for the band's 1987 album, React.\",\n        \"thumbnails\": {\n          \"default\": {\n            \"url\": \"https://i.ytimg.com/vi/cit17Si-Vts/default.jpg\",\n            \"width\": 120,\n            \"height\": 90\n          },\n          \"medium\": {\n            \"url\": \"https://i.ytimg.com/vi/cit17Si-Vts/mqdefault.jpg\",\n            \"width\": 320,\n            \"height\": 180\n          },\n          \"high\": {\n            \"url\": \"https://i.ytimg.com/vi/cit17Si-Vts/hqdefault.jpg\",\n            \"width\": 480,\n            \"height\": 360\n          },\n          \"standard\": {\n            \"url\": \"https://i.ytimg.com/vi/cit17Si-Vts/sddefault.jpg\",\n            \"width\": 640,\n            \"height\": 480\n          },\n          \"maxres\": {\n            \"url\": \"https://i.ytimg.com/vi/cit17Si-Vts/maxresdefault.jpg\",\n            \"width\": 1280,\n            \"height\": 720\n          }\n        },\n        \"channelTitle\": \"Larry Hinze\",\n        \"tags\": [\n          \"THE FIXX\",\n          \"Red Skies\"\n        ],\n        \"categoryId\": \"22\",\n        \"liveBroadcastContent\": \"none\",\n        \"localized\": {\n          \"title\": \"THE FIXX   Red Skies  1982    HQ\",\n          \"description\": \"\\\"Red Skies\\\" is a song by new wave rock group The Fixx. Released in 1982, it was the third single from the band's debut album, Shuttered Room. The song charted in the Netherlands, United Kingdom and United States, and was re-recorded for the band's 1987 album, React.\"\n        }\n      },\n      \"contentDetails\": {\n        \"duration\": \"PT4M21S\",\n        \"dimension\": \"2d\",\n        \"definition\": \"hd\",\n        \"caption\": \"false\",\n        \"licensedContent\": false,\n        \"contentRating\": {},\n        \"projection\": \"rectangular\"\n      },\n      \"statistics\": {\n        \"viewCount\": \"357992\",\n        \"likeCount\": \"3517\",\n        \"dislikeCount\": \"125\",\n        \"favoriteCount\": \"0\",\n        \"commentCount\": \"375\"\n      }\n    }\n  ],\n  \"pageInfo\": {\n    \"totalResults\": 1,\n    \"resultsPerPage\": 1\n  }\n}\n"
    @expected2 = "{\n  \"kind\": \"youtube#videoListResponse\",\n  \"etag\": \"ffwCvdMctkfT3r3dZATOA9TZuck\",\n  \"items\": [],\n  \"pageInfo\": {\n    \"totalResults\": 0,\n    \"resultsPerPage\": 0\n  }\n}\n"
    stub_request(:get, "https://www.googleapis.com/youtube/v3/videos?id=cit17Si-Vts&key=AIzaSyAtTp3fGqcu-LCxliFHUR035EtIpuXzqs4&part=snippet,contentDetails,statistics").
         to_return(status: 200, body: @expected)
    stub_request(:get, "https://www.googleapis.com/youtube/v3/videos?id=&key=AIzaSyAtTp3fGqcu-LCxliFHUR035EtIpuXzqs4&part=snippet,contentDetails,statistics").
         to_return(status: 200, body: @expected2)
  end
  it 'can add video when fields are filled out properly' do

    visit "/admin/dashboard"

    within(first(".admin-tutorial-card")) do
      click_on 'Edit'
    end

    expect(current_path).to eq(edit_admin_tutorial_path(@tutorial))
    fill_in'video_title', with: 'THE FIXX Red Skies 1982 HQ'
    fill_in'video_description', with: "\"Red Skies\" is a song by new wave rock group The Fixx. Released in 1982, it was the third single from the band's debut album, Shuttered Room. The song charted in the Netherlands, United Kingdom and United States, and was re-recorded for the band's 1987 album, React."
    fill_in'video_video_id', with: 'cit17Si-Vts'
    click_on 'Create Video'

    expect(page).to have_content('THE FIXX Red Skies 1982 HQ')
    expect(page).to have_content('Successfully created video.')
  end

  it 'can not add video when fields are not filled out properly' do

    visit "/admin/dashboard"

    within(first(".admin-tutorial-card")) do
      click_on 'Edit'
    end

    expect(current_path).to eq(edit_admin_tutorial_path(@tutorial))
    fill_in'video_title', with: 'Stand or Fall'
    fill_in'video_description', with: "Stand Or Fall · The Fixx"
    click_on 'Create Video'

    expect(page).not_to have_content('Stand or Fall')
    expect(page).to have_content('Unable to create video.')
  end
end
