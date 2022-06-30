class ClustersController < ApplicationController
  before_action :authorized

  def index
    clusters = current_user.clusters.sorted_by_view_order
    render json: ClusterBlueprint.render(clusters)
  end

  def update_clusters_order
    # Update clusters order
    if update_clusters_order_params[:clusters].size > 0
      grouped_clusters = update_clusters_order_params[:clusters].each_with_object({}) do |cluster, memo|
        memo[cluster[:id]] = { view_order: cluster[:view_order] }
      end

      current_user.clusters.update(grouped_clusters.keys, grouped_clusters.values)
    end

    # Update cluster_id for moved_widgets
    if update_clusters_order_params[:moved_widgets].size > 0
      current_user.clusters.each do |cluster|
        prepared = update_clusters_order_params[:moved_widgets].each_with_object({}) do |item, memo|
          if item[:prev_cluster_id] == cluster[:id]
            memo[item[:id]] = item[:next_cluster_id]
          else
            memo
          end
        end

        if prepared.present?
          cluster.coin_widgets.each do |coin_widget|
            if prepared[coin_widget[:id]]
              coin_widget.update(cluster_id: prepared[coin_widget[:id]])
            end
          end
        end
      end
    end

    # Update widgets order
    if update_clusters_order_params[:reordered_widgets].size > 0
      prepared = update_clusters_order_params[:reordered_widgets].each_with_object({}) do |item, memo|
        memo[item[:cluster_id]] = item[:coin_widgets].each_with_object({}) do |widget, memo|
          memo[widget[:id]] = { view_order: widget[:view_order] }
        end
      end

      current_user.clusters.each do |cluster|
        cluster_coin_widgets = prepared[cluster[:id].to_s]
        if cluster_coin_widgets
          cluster.coin_widgets.update(cluster_coin_widgets.keys, cluster_coin_widgets.values)
        end
      end
    end

    clusters = current_user.clusters.sorted_by_view_order
    render json: ClusterBlueprint.render(clusters)
  rescue
    render json: clusters, status: :unprocessable_entity
  end

  def create
    cluster = current_user.clusters.new(cluster_params)
    cluster.save!
    render json: ClusterBlueprint.render(cluster), status: :created
  rescue
    render json: cluster, status: :unprocessable_entity
  end

  def update
    current_cluster.update!(update_cluster_params)
    render json: ClusterBlueprint.render(current_cluster), status: :ok
  rescue
    render json: current_cluster, status: :unprocessable_entity
  end

  def destroy
    current_cluster.destroy
    head :no_content
  end

private
  def cluster_params
    params.permit(:name, :view_order)
  end

  def update_cluster_params
    params.permit(:name)
  end

  def update_clusters_order_params
    params.permit(
      clusters: %i[id view_order],
      moved_widgets: %i[id prev_cluster_id next_cluster_id],
      reordered_widgets: [:cluster_id, { coin_widgets: %i[id view_order] }]
    )
  end

  def current_cluster
    @_current_cluster ||= current_user.clusters.find(params[:id])
  end
end
