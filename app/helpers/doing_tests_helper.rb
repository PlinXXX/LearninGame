module DoingTestsHelper
	def authenticate_test
		if current_test.students.include? current_student
			redirect_to student_path(current_student.id),
			alert: "You are clever, but I'm more than you !"
		end
	end
	def dt_params
		params.permit(:student_id, :test_id)
	end

	def authenticate_student
		if current_user.status != "Student"
			redirect_to root_path,
			alert: "You are not allowed to access this content"
		end

		if current_test.questions.length == 0
			render :new,
			alert: "Ajoute au moins une question flemard!"
		end
	end

	def current_student
		Student.find(params[:student_id])
	end

	def current_test
		Test.find(params[:test_id])
	end

	def points_total(test)
		tot = 0
		test.questions.each do |question|
			tot += question.points
		end
		tot
	end

	def get_answers
		answers = []
		params.each do |k , v|
			answers << v if k.include? "opt"
		end
		answers
	end

	def check(answers)
		answers.length.times do |ans|
			opt = Option.where(content: answers[ans]).first
			if opt.status == "Correct"
				@test.score += @questions[ans].points
				Option.find_by(content: answers[ans]).update(status: "Right_answer")
			else
				Option.find_by(content: answers[ans]).update(status: "Wrong_answer")
			end
		end
		@test.save
	end

	def increase_score(student)
		student.score += (@test.score/2)
		student.save
	end
end