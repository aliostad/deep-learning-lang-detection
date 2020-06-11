/**
 * Created by gopi on 8/11/14.
 */
module.exports = function(sequelize, DataTypes) {

    var Show = sequelize.define('Show', {
            show_name: DataTypes.STRING,
            show_venue: DataTypes.TEXT,
            show_venue_details: DataTypes.TEXT,
            show_time: DataTypes.DATE,
            contact_phone: DataTypes.STRING,
            contact_email: DataTypes.STRING,
            contact_notes: DataTypes.TEXT
        },
        {
            associate: function(models){
                Show.belongsTo(models.User);
            }
        }
    );

    return Show;
};