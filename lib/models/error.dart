class ErrorModel {
    final String? type;
    final String? title;
    final int? status;
    final List<Error>? errors;

    ErrorModel({
        this.type,
        this.title,
        this.status,
        this.errors,
    });

    factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
        type: json["type"],
        title: json["title"],
        status: json["status"],
        errors: json["errors"] == null ? [] : List<Error>.from(json["errors"]!.map((x) => Error.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "title": title,
        "status": status,
        "errors": errors == null ? [] : List<dynamic>.from(errors!.map((x) => x.toJson())),
    };
}

class Error {
    final String? code;
    final String? description;
    final int? type;

    Error({
        this.code,
        this.description,
        this.type,
    });

    factory Error.fromJson(Map<String, dynamic> json) => Error(
        code: json["code"],
        description: json["description"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "description": description,
        "type": type,
    };
}
