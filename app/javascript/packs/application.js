// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
/*import Turbolinks from "turbolinks"*/
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
/*Turbolinks.start()*/
ActiveStorage.start()
require("jquery")
require("@nathanvda/cocoon")
require("/home/pavel/RubymineProjects/qna/app/javascript/packs/answers/answers")
require("/home/pavel/RubymineProjects/qna/app/javascript/packs/questions/questions")
require("/home/pavel/RubymineProjects/qna/app/javascript/packs/styles/answers.scss")
require("/home/pavel/RubymineProjects/qna/app/javascript/packs/styles/questions.scss")

let App = App || {}
App.cable = ActionCable.createConsumer();