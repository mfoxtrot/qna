module Voted
  extend ActiveSupport::Concern

   included do
     before_action :set_voted, only: [:vote_up, :vote_down, :vote_delete]

   end

   def vote_up
     unless current_user.author_of?(@voted)
       @vote = @voted.vote_up(current_user)
       respond_to do |format|
         format.json {
           render json: {vote: @vote, message: "You have successfully voted for the #{resource_name}", rating: @voted.rating}
         }
       end
     end
   end

   def vote_down
     unless current_user.author_of?(@voted)
       @vote = @voted.vote_down(current_user)
       respond_to do |format|
         format.json {
           render json: {vote: @vote, message: "You have successfully voted for the #{resource_name}", rating: @voted.rating}
         }
       end
     end
   end

   def vote_delete
     @voted.delete_vote(current_user)
     respond_to do |format|
       format.json {
         render json: {rating: @voted.rating, votable_id: @voted.id}
       }
     end
   end

   private

   def model_klass
     controller_name.classify.constantize
   end

   def set_voted
     @voted = model_klass.find(params[:id])
   end

   def resource_name
     controller_name.classify.underscore
   end
end
